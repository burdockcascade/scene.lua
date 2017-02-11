local scene = require('scene')

local describe = require('busted').describe
local it = require('busted').it

describe("errors in scene", function()
  it("cannot attach nil", function()
    local node = scene.node()
    assert.has.errors(function() node:attach(nil) end)
  end)

  it("cannot attach a non-node", function()
    local node = scene.node()
    assert.has.errors(function() node:attach({}) end)
  end)
end)
