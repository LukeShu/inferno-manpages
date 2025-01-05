-- build-aux/1e1/htmlclean.fixlinks.lua - A pandoc Lua filter to rewrite <a> links
--
-- Copyright (C) 2025  Luke T. Shumaker <lukeshu@lukeshu.com>
-- SPDX-License-Identifier: MIT

function Link(el)
   if #el.content == 0 then
      -- Drop invisible links.
      return {}
   end
   -- Rewrite the target.

   -- Generic
   el.target = el.target:gsub('.htm', '.phtml')

   -- These seem to be mistakes in the HTML
   if el.target:gmatch('^manpgch%.htm#.*') then
      return el.content
   end

   -- Generic
   el.target  = el.target:gsub('^' .. os.getenv('SELF') .. '.phtml', '')

   return el
end
