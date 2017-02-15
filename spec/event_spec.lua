local scene = require('scene')

local describe = require('busted').describe
local it = require('busted').it

describe("event listeners", function()
  it("can be attached to nodes", function()
    local node = scene.node()
    node:on("test", function(obj)
      obj.test_value = true
    end)

    local event = {test_value=false}
    node:fire("test", event)
    assert.is_true(event.test_value)
  end)

  it("can be removed", function()
    local node = scene.node()
    local listener = node:on("test", function()
      print("will be removed")
    end)

    assert.is_equal(#node.listeners["test"], 1)
    node:off("test", listener)
    assert.is_equal(#node.listeners["test"], 0)
  end)

  it("can be emitted", function()
    local node1 = scene.node()
    local node2 = scene.node()
    local node3 = scene.node()

    node1:attach(node2)
    node2:attach(node3)

    local listener = node1:on("test", function(obj)
      obj.test_value = obj.test_value + 1
    end)
    node2:on("test", listener)
    node3:on("test", listener)

    local test_obj = {test_value=0}
    node3:emit("test", test_obj)

    assert.is_equal(test_obj.test_value, 3)
  end)

  it("can be broadcasted", function()
    local node1 = scene.node{id="1"}
    local node2 = scene.node{id="2"}
    local node3 = scene.node{id="3"}

    node1:attach(node2)
    node1:attach(node3)

    node1:on("test", function(obj)
      table.insert(obj.received, node1)
    end)
    node2:on("test", function(obj)
      table.insert(obj.received, node2)
    end)
    node3:on("test", function(obj)
      table.insert(obj.received, node3)
    end)

    local test_obj = {received={}}
    node3:broadcast("test", test_obj)

    assert.is_equal(test_obj.received[1], node1)
    assert.is_equal(test_obj.received[2], node2)
    assert.is_equal(test_obj.received[3], node3)
  end)
end)
