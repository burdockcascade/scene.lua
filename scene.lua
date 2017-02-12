local scene = {}

--[[
Utility functions
--]]

local function max_bounds(x, y, half_width, half_height)
  return x + half_width, y + half_height
end

local function min_bounds(x, y, half_width, half_height)
  return x - half_width, y - half_height
end

--[[
A node representing a local transform.
--]]

local node = {}
node.__index = node

setmetatable(node, {
    __call = function(self, params)
      local new_node = setmetatable({}, self)
      self.init(new_node, params)
      return new_node
    end
  })

function node:init(params)
  self.x = (params and params.x) or 0
  self.y = (params and params.y) or 0
  self.sx = (params and params.sx) or 1
  self.sy = (params and params.sy) or 1
  self.rot = (params and params.rot) or 0
  self.halfw = (params and params.halfw) or 0
  self.halfh = (params and params.halfh) or 0
  self.id = params and params.id
  self.root = self
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

  -- Add child to parent
  table.insert(self.children, child)
  child.parent = self
  child.pos_in_parent = #self.children
  child.root = self.root

  -- Set up access to child based on id
  if child.id then
    self.root.ids = self.root.ids or {}

    if self.root.ids[child.id] then
      error("non-unique id: " .. child.id)
    end

    self.root.ids[child.id] = child
  end

  self:expand_bounds(child:as_aabb())
end

function node:detach()
  if self.parent then
    table.remove(self.parent.children, self.pos_in_parent)
    self.parent = nil
    self.pos_in_parent = nil
    self.root = nil
  end
end

function node:get_node(id)
  return (self.root.id == id and self.root) or self.root.ids[id]
end

function node:apply_transform(xform)
  xform = xform or {}
  xform.x = (xform.x or 0) + self.x
  xform.y = (xform.y or 0) + self.y

  xform.sx = (xform.sx or 1) * self.sx
  xform.sy = (xform.sy or 1) * self.sy

  xform.rot = (xform.rot or 0) + self.rot
  return xform
end

function node:as_aabb()
  return self.x, self.y, self.halfw, self.halfh
end

function node:intersects(x, y, hw, hh)
  return (math.abs(self.x - x) < (self.halfw + hw)) and
    (math.abs(self.y - y) < (self.halfh - hh))
end

-- Checks if a node contains the point or AABB
function node:contains(x, y, hw, hh)
  if not hw or not hh then
    return (math.abs(self.x - x) < self.halfw) and
      (math.abs(self.y - y) < self.halfh)
  end

  local maxx, maxy = x + hw, y + hh
  local minx, miny = x - hw, y - hh
  return self:contains(maxx, maxy) and self:contains(minx, miny)
end

-- Expands the node's bounds to encompass the given AABB or point.
function node:expand_bounds(x, y, hw, hh)
  hw = hw or 0
  hh = hh or 0
  local maxx, maxy = max_bounds(self:as_aabb())
  local minx, miny = min_bounds(self:as_aabb())
  local cmaxx, cmaxy = max_bounds(x, y, hw, hh)
  local cminx, cminy = min_bounds(x, y, hw, hh)

  if maxx < cmaxx then
    maxx = cmaxx
    self.halfw = maxx - self.x
  end

  if maxy < cmaxy then
    maxy = cmaxy
    self.halfh = maxy - self.y
  end

  if minx > cminx then
    minx = cminx
    self.halfw = self.x - minx
  end

  if miny > cminy then
    miny = cminy
    self.halfh = self.y - miny
  end
end

-- A helper function to calculate the node bounds when positions have changed.
function node:calc_bounds()
  for _, child in ipairs(self.children) do
    self:expand_bounds(child:as_aabb())
  end
end

scene.node = node

-----------------------------------------------

return scene
