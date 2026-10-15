-- Tri-state collection store with save-epoch isolation.
-- States: unknown, remaining, collected.
-- Collection is terminal within one epoch; only a new epoch resets all state.
local State = {}
State.__index = State

function State.New(ids)
  if type(ids) ~= "table" or #ids == 0 then error("State.New requires a non-empty id list") end
  local whitelist, states = {}, {}
  local seen = {}
  for _, id in ipairs(ids) do
    if type(id) ~= "string" or id == "" then error("State.New: each id must be a non-empty string") end
    if seen[id] then error("State.New: duplicate id: " .. id) end
    seen[id] = true
    whitelist[#whitelist + 1] = id
    states[id] = "unknown"
  end
  return setmetatable({
    _whitelist = whitelist,
    _states = states,
    _epoch = 0,
    _revision = 0,
  }, State)
end

function State:BeginEpoch(epoch)
  if type(epoch) ~= "number" or epoch < 0 or epoch > 9007199254740991 or epoch ~= math.floor(epoch) then
    error("BeginEpoch: epoch must be a nonnegative integer")
  end
  if epoch <= self._epoch and self._epoch > 0 then
    error("BeginEpoch: epoch must advance (got " .. tostring(epoch) .. ", current " .. tostring(self._epoch) .. ")")
  end
  if epoch == 0 and self._epoch == 0 then return false end
  self._epoch = epoch
  local changed = false
  for _, id in ipairs(self._whitelist) do
    if self._states[id] ~= "unknown" then
      self._states[id] = "unknown"
      changed = true
    end
  end
  if changed or epoch > 0 then
    self._revision = self._revision + 1
  end
end

function State:Get(id)
  if self._states[id] == nil then return nil end
  return self._states[id]
end

function State:Revision()
  return self._revision
end

function State:Epoch()
  return self._epoch
end

function State:Counts()
  local counts = {unknown=0, remaining=0, collected=0}
  for _, state in pairs(self._states) do counts[state] = counts[state] + 1 end
  return counts
end

function State:Observe(id, state, epoch)
  -- Reject unknown IDs
  if self._states[id] == nil then return false end
  -- Reject invalid states
  if state ~= "remaining" and state ~= "collected" then return false end
  -- Reject stale epoch
  if epoch ~= self._epoch then return false end
  -- Collection is terminal within an epoch: ignore remaining after collected
  if self._states[id] == "collected" then
    return true  -- accepted but no change
  end
  local old = self._states[id]
  self._states[id] = state
  if old ~= state then
    self._revision = self._revision + 1
  end
  return true
end

function State:ApplySnapshot(statesById, epoch)
  -- Validate epoch
  if epoch ~= self._epoch then return false end
  -- Validate full snapshot before any mutation
  if type(statesById) ~= "table" then return false end
  for id, value in pairs(statesById) do
    if self._states[id] == nil then return false end
    if value ~= "unknown" and value ~= "remaining" and value ~= "collected" then return false end
  end
  -- Apply: respect collection terminal rule
  local changed = false
  for id, value in pairs(statesById) do
    if value ~= "unknown" and self._states[id] ~= "collected" and self._states[id] ~= value then
      self._states[id] = value
      changed = true
    end
  end
  if changed then
    self._revision = self._revision + 1
  end
  return true
end

return State
