local _conf = {
  scale = 1
}

function scale(val)
  if val then
    _conf.scale = val
  end
  return _conf.scale
end

return {
  scale = scale
}
