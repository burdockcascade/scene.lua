local scene = require('scene')

local describe = require('busted').describe
local it = require('busted').it

describe("bounding box", function()
  it("expands when adding children", function()
    local node = scene.node()
    local child = scene.node{x=10, y=10}

    assert.is_equal(node.halfw, 0)
    assert.is_equal(node.halfh, 0)

    node:attach(child)
    assert.is_equal(node.halfw, 10)
    assert.is_equal(node.halfh, 10)
  end)

  it("can intersect other bounding boxes", function()
    local node1 = scene.node{x=5, y=5, halfw=5, halfh=5}
    local node2 = scene.node{x=-5, y=-5, halfw=5, halfh=5}

    assert.is_true(node1:intersects(node2:as_aabb()))
    assert.is_true(node1:intersects(5, 5, 1, 1))
  end)

  it("can contain points or bounding boxes", function()
    local node1 = scene.node{x=5, y=5, halfw=5, halfh=5}

    assert.is_true(node1:contains(1, 1))
    assert.is_false(node1:contains(-1, 1))
    assert.is_true(node1:contains(2, 2, 1, 1))
    assert.is_false(node1:contains(2, 2, 5, 5))
  end)
end)
