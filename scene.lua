local scene = {}

scene.node = {}
scene.node.__index = scene.node

setmetatable(scene.node, {
  __call = function()
    local new_node = setmetatable({}, scene.node)
    scene.node.init(new_node)
    return new_node
  end
})

function scene.node:init()

end

function scene.node:attach(parent)
  self:detach()
  self.parent = parent
  if not parent.children then
    parent.children = {}
  end
  table.insert(parent.children, self)
  self.pos_in_parent = #parent.children
end

function scene.node:detach()
  if self.parent then
    table.remove(self.parent.children, self.pos_in_parent)
    self.parent = nil
    self.pos_in_parent = nil
  end
end
