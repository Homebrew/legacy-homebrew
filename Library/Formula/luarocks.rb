require 'formula'

class Luarocks < Formula
  homepage 'http://luarocks.org'
  url 'http://luarocks.org/releases/luarocks-2.0.11.tar.gz'
  sha1 '5f246b3ba33d671560ace74531f5d963f4729c4a'

  option 'with-luajit', 'Use LuaJIT instead of the stock Lua'

  if build.include? 'with-luajit'
    depends_on 'luajit'
  elsif build.include? 'with-lua52'
    depends_on 'lua52'
  else
    depends_on 'lua'
  end

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  # See comments at __END__
  def patches
    DATA if HOMEBREW_PREFIX.to_s == '/usr/local'
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks"]

    if build.include? 'with-luajit'
      args << "--with-lua-include=#{HOMEBREW_PREFIX}/include/luajit-2.0"
      args << "--lua-suffix=jit"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    opoo "Luarocks test script installs 'lpeg'"
    system "#{bin}/luarocks", "install", "lpeg"
    system "lua", "-llpeg", "-e", 'print ("Hello World!")'
  end
end


# This patch because we set the permissions of /usr/local to root owned
# not user writable to be "good" citizens of /usr/local. Actually LUA is being
# pedantic since all the directories it wants under /usr/local are writable
# so we just return true. Naughty, but I don't know LUA and don't want to
# write a better patch.
__END__
diff --git a/src/luarocks/fs/lua.lua b/src/luarocks/fs/lua.lua
index 67c3ce0..2d149c7 100644
--- a/src/luarocks/fs/lua.lua
+++ b/src/luarocks/fs/lua.lua
@@ -666,24 +666,5 @@ end
 -- @return boolean or (boolean, string): true on success, false on failure,
 -- plus an error message.
 function check_command_permissions(flags)
-   local root_dir = path.root_dir(cfg.rocks_dir)
-   local ok = true
-   local err = ""
-   for _, dir in ipairs { cfg.rocks_dir, root_dir, dir.dir_name(root_dir) } do
-      if fs.exists(dir) and not fs.is_writable(dir) then
-         ok = false
-         err = "Your user does not have write permissions in " .. dir
-         break
-      end
-   end
-   if ok then
-      return true
-   else
-      if flags["local"] then
-         err = err .. " \n-- please check your permissions."
-      else
-         err = err .. " \n-- you may want to run as a privileged user or use your local tree with --local."
-      end
-      return nil, err
-   end
+   return true
 end
diff --git a/src/luarocks/cfg.lua b/src/luarocks/cfg.lua
--- a/src/luarocks/cfg.lua
+++ a/src/luarocks/cfg.lua
@@ -10,8 +10,8 @@
 -- (~/.luarocks/config.lua on Unix or %APPDATA%/luarocks/config.lua on
 -- Windows).
 
-local rawset, next, table, pairs, require, io, os, setmetatable, pcall, ipairs, package, type, assert, _VERSION =
-      rawset, next, table, pairs, require, io, os, setmetatable, pcall, ipairs, package, type, assert, _VERSION
+local tonumber, rawset, next, table, pairs, require, io, os, setmetatable, pcall, ipairs, package, type, assert, _VERSION =
+      tonumber, rawset, next, table, pairs, require, io, os, setmetatable, pcall, ipairs, package, type, assert, _VERSION
 
 module("luarocks.cfg")
 
