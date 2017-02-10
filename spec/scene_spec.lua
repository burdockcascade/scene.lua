local scene = require('scene')

local describe = require('busted').describe
local it = require('busted').it

describe("a simple scene", function()
  it("can be a single node", function()
    assert.is_truthy(scene.node())
  end)

  it("can have children", function()
    local node = scene.node()
    local child = scene.node()
    local child2 = scene.node()

    assert.is_truthy(node)
    assert.is_truthy(child)
    assert.is_truthy(child2)

    node:attach(child)
    assert.is_equal(#node.children, 1)
    --
    node:attach(child2)
    assert.is_equal(#node.children, 2)
  end)

  it("can add and remove children", function()
    local node = scene.node()
    local child = scene.node()

    assert.is_truthy(node)
    assert.is_truthy(child)

    node:attach(child)
    assert.is_equal(#node.children, 1)

    child:detach()
    assert.is_equal(#node.children, 0)
  end)
end)
