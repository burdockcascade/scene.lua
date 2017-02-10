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

function scene.node:attach(child)
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

function scene.node:detach()
  if self.parent then
    table.remove(self.parent.children, self.pos_in_parent)
    self.parent = nil
    self.pos_in_parent = nil
  end
end

return scene
