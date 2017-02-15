local scene = require('scene')

local describe = require('busted').describe
local it = require('busted').it

describe("scene creation", function()
  it("can be uninitialized", function()
    assert.is_truthy(scene.node())
  end)

  it("can be initialized", function()
    local params = {
      x = 1,
      y = 2,
      sx = 3,
      sy = 4,
      rot = 5,
      halfw = 6,
      halfh = 7,
      id = "some_id"
    }
    local root = scene.node(params)

    for key, value in pairs(params) do
      assert.is_equal(value, root[key])
    end
  end)
end)

describe("scene hierarchy", function()
  it("can add children", function()
    local parent = scene.node()
    local child1 = scene.node()
    local child2 = scene.node()

    parent:attach(child1)
    assert.is_equal(#parent.children, 1)
    assert.is_equal(parent.children[1], child1)
    --
    parent:attach(child2)
    assert.is_equal(#parent.children, 2)
    assert.is_equal(parent.children[2], child2)
  end)

  it("can remove children", function()
    local parent = scene.node()
    local child = scene.node()

    parent:attach(child)
    child:detach()
    assert.is_equal(#parent.children, 0)
    assert.is_nil(child.parent)
  end)

  it("can change parents", function()
    local parent1 = scene.node()
    local parent2 = scene.node()
    local child = scene.node()

    parent1:attach(child)
    parent2:attach(child)
    assert.is_equal(#parent2.children, 1)
    assert.is_equal(child.parent, parent2)
  end)
end)

describe("node accessors", function()
  it("can access the root node", function()
    local root = scene.node()
    local node1 = scene.node()
    local node2 = scene.node()

    root:attach(node1)
    assert.is_equal(node1:get_root(), root)

    node1:attach(node2)
    assert.is_equal(node2:get_root(), root)
  end)

  it("can access nodes by id", function()
    local root = scene.node{id="root"}
    local node1 = scene.node{id="node1"}
    local node2 = scene.node{id="node2"}

    node1:attach(node2)
    root:attach(node1)

    assert.is_equal(node1:get_node("root"), root)
    assert.is_equal(node2:get_node("node1"), node1)
    assert.is_equal(root:get_node("node2"), node2)
  end)
end)
