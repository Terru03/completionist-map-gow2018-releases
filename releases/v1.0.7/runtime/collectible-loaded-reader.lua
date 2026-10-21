-- Exact ancestry + adapter tag; an absent or ambiguous object is unknown.
local Loaded = {}
Loaded.__index = Loaded

local function plain(value)
  if type(value) ~= 'string' then return nil end
  value = value:lower()
  return value:sub(1, 2) == 'go' and value:sub(3) or value
end

local function nameMatches(obj, expected)
  if obj == nil or type(expected) ~= 'string' then return false end
  local ok, objName = pcall(obj.GetName, obj)
  if not ok or type(objName) ~= 'string' then return false end
  return plain(objName) == plain(expected) or objName:lower() == expected:lower()
end

local function pathMatches(object, names)
  if object == nil or type(names) ~= 'table' or #names == 0 then return false end
  local curr = object
  for _, name in ipairs(names) do
    if curr == nil then return false end
    if not nameMatches(curr, name) then return false end
    curr = curr.Parent
  end
  return true
end

local function unique(objects, names, parent)
  if type(objects) ~= 'table' then return nil end
  local found
  for _, object in pairs(objects) do
    if pathMatches(object, names) and (parent == nil or object.Parent == parent) then
      if found ~= nil then return nil end
      found = object
    end
  end
  return found
end

local function observeScript(obj, adapter)
  if obj == nil then return nil end
  local script = obj.LuaObjectScript
  if script == nil then return nil end
  if type(script.CompletionistCollectibleObserve) == 'function' then
    local ok, retAdapter, retState = pcall(script.CompletionistCollectibleObserve)
    if ok and retAdapter == adapter and (retState == 'remaining' or retState == 'collected') then
      return retState
    end
  end
  if adapter == 'chest' then
    if type(script.IsOpen) == 'function' then
      local ok, open = pcall(script.IsOpen)
      if ok and type(open) == 'boolean' then
        return open and 'collected' or 'remaining'
      end
    end
    if type(script.GetState) == 'function' then
      local ok, st = pcall(script.GetState)
      if ok and type(st) == 'number' then
        return st == 4 and 'collected' or 'remaining'
      end
    end
  elseif adapter == 'artefact' then
    if type(script.GetState) == 'function' then
      local ok, st = pcall(script.GetState)
      if ok and type(st) == 'number' then
        return st == 3 and 'collected' or 'remaining'
      end
    end
  elseif adapter == 'dig' then
    if type(script.GetState) == 'function' then
      local ok, st = pcall(script.GetState)
      if ok and type(st) == 'number' then
        if st == 3 then
          local q = script.questName
          if type(q) == 'string' and q ~= '' and type(game.QuestManager) == 'table' and type(game.QuestManager.GetQuestState) == 'function' then
            local ok2, qst = pcall(game.QuestManager.GetQuestState, q)
            if ok2 and qst == 'Complete' then return 'collected' end
            return 'remaining'
          end
          return 'collected'
        end
        return 'remaining'
      end
    end
  elseif adapter == 'shrine' then
    if type(script.IsTriptychCompleted) == 'function' then
      local ok, done = pcall(script.IsTriptychCompleted)
      if ok and type(done) == 'boolean' then
        return done and 'collected' or 'remaining'
      end
    end
  elseif adapter == 'rift' then
    if type(script.hasOpened) == 'boolean' then
      return script.hasOpened and 'collected' or 'remaining'
    end
    if type(script.GetState) == 'function' then
      local ok, st = pcall(script.GetState)
      if ok and type(st) == 'number' then
        return st == 4 and 'collected' or 'remaining'
      end
    end
  end
  return nil
end

local function isAncestorOf(ancestor, node, maxLevels)
  if ancestor == nil or node == nil then return false end
  local curr = node.Parent
  for _ = 1, (maxLevels or 8) do
    if curr == nil then return false end
    if curr == ancestor then return true end
    curr = curr.Parent
  end
  return false
end

local function read(row)
  local level = game.FindLevel(row.level)
  if level == nil then
    level = game.FindLevel('WAD_' .. row.level)
  end
  if level == nil then
    level = game.FindLevel('wad_' .. row.level)
  end
  if level == nil then return nil end

  local pQuery = plain(row.placement[1])
  local placementMatches = level:FindGameObjects(pQuery)
  if (placementMatches == nil or #placementMatches == 0) and type(level.FindGameObjects) == 'function' then
    placementMatches = level:FindGameObjects(row.placement[1])
  end
  if (placementMatches == nil or #placementMatches == 0) and type(level.FindSingleGameObject) == 'function' then
    local single = level:FindSingleGameObject(pQuery) or level:FindSingleGameObject(row.placement[1])
    if single then placementMatches = {single} end
  end

  local placement = unique(placementMatches, row.placement)
  if placement == nil and placementMatches ~= nil and #placementMatches == 1 and nameMatches(placementMatches[1], row.placement[1]) then
    placement = placementMatches[1]
  end
  if placement == nil or not nameMatches(placement, row.placement[1]) then return nil end

  local owner = placement
  if #row.owner > #row.placement then
    local oQuery = plain(row.owner[1])
    local oMatches = nil
    if type(placement.FindGOsByName) == 'function' then
      oMatches = placement:FindGOsByName(oQuery)
      if (oMatches == nil or #oMatches == 0) and oQuery ~= row.owner[1] then
        oMatches = placement:FindGOsByName(row.owner[1])
      end
    end
    local validMatches = {}
    for _, match in ipairs(oMatches or {}) do
      if nameMatches(match, row.owner[1]) then
        validMatches[#validMatches + 1] = match
      end
    end
    oMatches = validMatches
    owner = unique(oMatches, row.owner)
    if owner == nil and #oMatches == 1 then
      owner = oMatches[1]
    end
    if owner == nil then
      if (row.adapter == 'chest' or row.adapter == 'rift' or row.adapter == 'artefact') and #oMatches == 0 then
        owner = placement
      else
        return nil
      end
    end
    if owner ~= placement then
      local ancestor = owner
      -- The exact placement can have collapsed outer scene ancestors at runtime.
      -- Validate every inner owner node and anchor it to that placement object.
      for index = 1, #row.owner - #row.placement do
        if ancestor == nil or not nameMatches(ancestor, row.owner[index]) then return nil end
        ancestor = ancestor.Parent
      end
      if ancestor ~= placement then return nil end
    end
  end

  -- 1. Check owner directly
  local state = observeScript(owner, row.adapter)
  if state ~= nil then return state end
  if placement ~= nil and placement ~= owner then
    state = observeScript(placement, row.adapter)
    if state ~= nil then return state end
  end

  -- 2. If extra is specified, search inside owner
  if row.extra then
    local eQuery = plain(row.extra)
    local child = nil
    if type(owner.FindGOsByName) == 'function' then
      child = unique(owner:FindGOsByName(eQuery), {row.extra})
    end
    if child == nil and type(owner.FindSingleGOByName) == 'function' then
      child = owner:FindSingleGOByName(eQuery)
    end
    if child ~= nil and isAncestorOf(owner, child, 6) then
      local st = observeScript(child, row.adapter)
      if st ~= nil then return st end
      if child.Child ~= nil then
        st = observeScript(child.Child, row.adapter)
        if st ~= nil then return st end
      end
    end
  end

  -- 3. Descendants stepping via Child
  local curr = owner
  for _ = 1, 4 do
    if curr == nil then break end
    local st = observeScript(curr, row.adapter)
    if st ~= nil then return st end
    if curr.Child == nil or curr.Child.Parent ~= curr then break end
    curr = curr.Child
  end

  -- 4. Fast direct lookup for chest scripts under placement or owner
  if row.adapter == 'chest' then
    for _, container in ipairs({owner, placement}) do
      if container ~= nil and type(container.FindSingleGOByName) == 'function' then
        for _, q in ipairs({'gochestscript', 'chestscript', '*chestscript*'}) do
          local ok, node = pcall(container.FindSingleGOByName, container, q)
          if ok and node ~= nil then
            local st = observeScript(node, row.adapter)
            if st ~= nil then return st end
            if node.Child then
              st = observeScript(node.Child, row.adapter)
              if st ~= nil then return st end
            end
          end
        end
      end
    end
  end

  -- 5. Fast direct lookup for rift scripts under placement or owner
  if row.adapter == 'rift' then
    local containers = {owner, placement}
    if owner ~= nil and owner.Parent ~= nil then
      containers[#containers + 1] = owner.Parent
    end
    if placement ~= nil and placement.Parent ~= nil then
      containers[#containers + 1] = placement.Parent
    end
    for _, container in ipairs(containers) do
      if container ~= nil and type(container.FindSingleGOByName) == 'function' then
        for _, q in ipairs({'gopocketrift_interact_loot', 'pocketrift_interact_loot', '*interact_loot*', '*pocketrift*'}) do
          local ok, node = pcall(container.FindSingleGOByName, container, q)
          if ok and node ~= nil then
            local st = observeScript(node, row.adapter)
            if st ~= nil then return st end
            if node.Child then
              st = observeScript(node.Child, row.adapter)
              if st ~= nil then return st end
            end
          end
        end
      end
      if container ~= nil and type(container.FindGOsByName) == 'function' then
        for _, q in ipairs({'gopocketrift_interact_loot', 'pocketrift_interact_loot', '*interact_loot*'}) do
          local ok, nodes = pcall(container.FindGOsByName, container, q)
          if ok and type(nodes) == 'table' then
            for _, node in ipairs(nodes) do
              local st = observeScript(node, row.adapter)
              if st ~= nil then return st end
              if node.Child then
                st = observeScript(node.Child, row.adapter)
                if st ~= nil then return st end
              end
            end
          end
        end
      end
    end
  end

  -- 6. Fast direct lookup for artefact scripts under placement or owner
  if row.adapter == 'artefact' then
    local containers = {owner, placement}
    if owner ~= nil and owner.Parent ~= nil then
      containers[#containers + 1] = owner.Parent
    end
    if placement ~= nil and placement.Parent ~= nil then
      containers[#containers + 1] = placement.Parent
    end
    for _, container in ipairs(containers) do
      if container ~= nil and type(container.FindSingleGOByName) == 'function' then
        for _, q in ipairs({'goartifactscript', 'artifactscript', '*artifact*'}) do
          local ok, node = pcall(container.FindSingleGOByName, container, q)
          if ok and node ~= nil then
            local st = observeScript(node, row.adapter)
            if st ~= nil then return st end
            if node.Child then
              st = observeScript(node.Child, row.adapter)
              if st ~= nil then return st end
            end
          end
        end
      end
      if container ~= nil and type(container.FindGOsByName) == 'function' then
        for _, q in ipairs({'goartifactscript', 'artifactscript', '*artifact*'}) do
          local ok, nodes = pcall(container.FindGOsByName, container, q)
          if ok and type(nodes) == 'table' then
            for _, node in ipairs(nodes) do
              local st = observeScript(node, row.adapter)
              if st ~= nil then return st end
              if node.Child then
                st = observeScript(node.Child, row.adapter)
                if st ~= nil then return st end
              end
            end
          end
        end
      end
    end
  end

  return nil
end

function Loaded.New(rows, runtime)
  return setmetatable({rows = rows, runtime = runtime, nextRead = 0}, Loaded)
end

function Loaded:Poll(levelName)
  if type(game.FindLevel) ~= 'function' then return false end
  local epoch = self.runtime.store:Epoch()
  local accepted = {}
  for _, row in ipairs(self.rows) do
    if levelName == nil or row.level == levelName then
      local ok, state = pcall(read, row)
      if ok and state ~= nil then
        if accepted[row.id] then
          accepted[row.id] = 'unknown'
        else
          accepted[row.id] = state
        end
      end
    end
  end
  local before = self.runtime.store:Revision()
  if self.runtime.store:Epoch() == epoch then
    for id, state in pairs(accepted) do
      self.runtime.store:Observe(id, state, epoch)
    end
  end
  if self.runtime.store:Revision() ~= before then self.runtime:Changed() end
  return true
end

return Loaded
