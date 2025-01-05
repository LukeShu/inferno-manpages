-- build-aux/1e0/html2man.fixlinks.lua - A pandoc Lua filter to rewrite <a> links
--
-- Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
-- SPDX-License-Identifier: MIT

local pandoc_utils = require 'pandoc.utils'

local function read_names(filename)
   local chap = nil
   local names = {}
   for line in io.lines(filename) do
      if chap == nil then
	 chap = line:match('%((.+)%)$')
      end
      names[#names + 1] = line:gsub('%(' .. chap .. '%)$', '')
   end
   return {chap, names}
end

local function firstword(str)
   return str:match("^%S+")
end

local function in_list(needle, list)
   for _, straw in ipairs(list) do
      if straw == needle then
	 return true
      end
   end
   return false
end

function Link(el)
   local file = el.target:gsub('#.*$', '')
   local frag = ''
   if base ~= el.target then
      frag = el.target:gsub('^.*#', '')
   end
   if file == '' then
      -- TODO: Do something with 'frag'
      return el
   end
   chap, names = table.unpack(read_names(os.getenv('tmp_dir') .. '/' .. file:gsub(".phtml$", ".names")))
   local content_name = firstword(pandoc_utils.stringify(el.content))
   if in_list(content_name, names) then
      name = content_name
   else
      name = names[1]
   end
   -- TODO: Do something with 'frag'
   return pandoc.RawInline('man', '\n.IR ' .. name .. ' (' .. chap .. ')\n')
end
