-- One store survives map opens; the existing Raven/Nornir lifecycle owns epochs.
local Runtime = {}
Runtime.__index = Runtime
function Runtime.New(store, reader)
  return setmetatable({store=store, reader=reader, ready=false}, Runtime)
end
function Runtime:Changed(boundary)
  local counts=self.store:Counts()
  print('[CompletionistLocations] state epoch='..tostring(self.store:Epoch())..
    ' collected='..tostring(counts.collected)..' remaining='..tostring(counts.remaining)..
    ' unknown='..tostring(counts.unknown))
  local notify = _G.CompletionistMapV105LocationStateChanged
  if type(notify) == 'function' then notify(boundary == true) end
end
function Runtime:BeginEpoch(epoch)
  if epoch <= self.store:Epoch() then return false end
  self.ready=false; self.restoreEpoch=nil
  self.store:BeginEpoch(epoch); self.reader:Reset(epoch)
  self.nextLoadedRead=nil
  self.nextAuthorityRead=nil
  self:Changed(true)
  return true
end
function Runtime:AuthorityReady(restore)
  if type(restore) ~= 'number' or restore < 0 or restore > 9007199254740991 or
      restore ~= math.floor(restore) then return false end
  self.restoreEpoch=restore; self.ready=true
  return true
end
function Runtime:Observe(id, state, epoch)
  if not self.ready then return false end
  local before=self.store:Revision()
  local accepted=self.store:Observe(id,state,epoch)
  if self.store:Revision() ~= before then self:Changed() end
  return accepted
end
function Runtime:Tick(dt)
  self.reader:Advance(dt)
  return self:Poll()
end
function Runtime:Poll()
  if self.cleanup then self.cleanup() end
  local epoch=self.store and self.store:Epoch() or 0
  if self.directObserver then
    pcall(self.directObserver, self, epoch)
  end
  if self.loaded then
    local now=self.reader.transport and self.reader.transport.now() or nil
    if now == nil then self.frames=(self.frames or 0)+1; now=self.frames/60 end
    if self.nextLoadedRead == nil or now >= self.nextLoadedRead then
      self.nextLoadedRead=now+2
      self.loaded:Poll()
    end
  end
  if not self.ready then
    local refresh=_G.CompletionistMapV105RefreshLocationAuthority
    local now=self.reader.transport and self.reader.transport.now() or self.reader.elapsed
    if type(refresh) == 'function' and (self.nextAuthorityRead == nil or now >= self.nextAuthorityRead) then
      self.nextAuthorityRead=now+2
      pcall(refresh)
    end
  end
  if not self.ready then return false end
  local snapshot=self.reader:Poll(epoch)
  if not snapshot or snapshot.epoch ~= epoch or snapshot.restoreEpoch ~= self.restoreEpoch then return false end
  local before=self.store:Revision()
  if not self.store:ApplySnapshot(snapshot.states,epoch) then return false end
  if self.store:Revision() ~= before then self:Changed() end
  return true
end
return Runtime
