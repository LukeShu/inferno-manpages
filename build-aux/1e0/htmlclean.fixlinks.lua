-- build-aux/1e0/htmlclean.fixlinks.lua - A pandoc Lua filter to rewrite <a> links
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

   -- This mirrors $(htmlnames/intros) in Makefile
   --                                                                 -- There is no chapter 1.
   el.target = el.target:gsub('^(devices)%.phtml', '%1-0intro.phtml') -- chapter 2
   el.target = el.target:gsub('^(proto)%.phtml'  , '%1-0intro.phtml') -- chapter 3
   el.target = el.target:gsub('^(cmd_env)%.phtml', '%1-0intro.phtml') -- chapter 4
   el.target = el.target:gsub('^(cmd)%.phtml'    , '%1-0intro.phtml') -- chapter 5
   el.target = el.target:gsub('^(daemons)%.phtml', '%1-0intro.phtml') -- chapter 6
   el.target = el.target:gsub('^i_modu%.phtml'   , 'md-0intro.phtml') -- chapter 7; NB: this doesn't use %1
   el.target = el.target:gsub('^(md_sys)%.phtml' , '%1-0intro.phtml') -- chapter 8
   el.target = el.target:gsub('^(md_sec)%.phtml' , '%1-0intro.phtml') -- chapter 9
   --                                                                 -- There is no chapter 10.
   el.target = el.target:gsub('^(md_draw)%.phtml', '%1-0intro.phtml') -- chapter 11
   el.target = el.target:gsub('^(md_pref)%.phtml', '%1-0intro.phtml') -- chapter 12
   el.target = el.target:gsub('^(md_tk)%.phtml'  , '%1-0intro.phtml') -- chapter 13
   el.target = el.target:gsub('^(md_math)%.phtml', '%1-0intro.phtml') -- chapter 14
   el.target = el.target:gsub('^(md_misc)%.phtml', '%1-0intro.phtml') -- chapter 15
   el.target = el.target:gsub('^(formats)%.phtml', '%1-0intro.phtml') -- chapter A

   -- This mirrors $(htmlnames/deny) in Makefile
   el.target = el.target:gsub('^md_sec1%.phtml' , 'md_sec-0intro.phtml')
   el.target = el.target:gsub('^md_sec2%.phtml' , 'md_sec-0intro.phtml')
   el.target = el.target:gsub('^md_sec3%.phtml' , 'md_sec-0intro.phtml')
   el.target = el.target:gsub('^md_sec22%.phtml', 'md_sec-0intro.phtml')
   el.target = el.target:gsub('^md_tk1%.phtml', 'md_tk-0intro.phtml')

   -- These seem to be mistakes in the HTML
   if el.target == 'md_sec14.phtml#847464' then el.target = el.target:gsub('14', '15') end
   if el.target == 'md_sec19.phtml#846000' then el.target = el.target:gsub('19', '20') end

   return el
end
