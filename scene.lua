local scene = {}

local node = {}
node.__index = node

setmetatable(node, {
  __call = function()
    local new_node = setmetatable({}, node)
    node.init(new_node)
    return new_node
  end
})

function node:init()
  self.x = 0
  self.y = 0
  self.sx = 1
  self.sy = 1
  self.rot = 0
end

function node:attach(child)
  if not child then
    error("cannot attach nil.")
  elseif getmetatable(child) ~= scene.node then
    error("cannot attach non-node.")
  end
  child:detach()
  if not self.children then
    self.children = {}
  end
  table.insert(self.children, child)
  child.parent = self
  child.pos_in_parent = #self.children
end

function node:detach()
  if self.parent then
    table.remove(self.parent.children, self.pos_in_parent)
    self.parent = nil
    self.pos_in_parent = nil
  end
end

scene.node = node

function scene.extend(derived, parent)
  derived.__super = parent
  return setmetatable(derived, {
    __index=parent
  })
end

return scene
