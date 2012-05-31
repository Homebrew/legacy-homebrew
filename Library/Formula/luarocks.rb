require 'formula'

def use_luajit?; ARGV.include? '--with-luajit'; end

class Luarocks < Formula
  homepage 'http://luarocks.org'
  url 'http://luarocks.org/releases/luarocks-2.0.8.tar.gz'
  md5 '07cf84e352d86fe161f7b2ec43f360cc'

  depends_on use_luajit? ? 'luajit' : 'lua'

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def patches
    p = []
    p << DATA if HOMEBREW_PREFIX.to_s == '/usr/local'
    # Allow parallel builds; will be in 2.0.9
    p << "https://github.com/keplerproject/luarocks/commit/0431ed91571e4b7986a1178df48232abff7c0916.patch"
    p
  end

  def options
    [['--with-luajit', 'Use LuaJIT instead of the stock Lua.']]
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks"]

    if use_luajit?
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
index 3a547fe..ca4ddc5 100644
--- a/src/luarocks/fs/lua.lua
+++ b/src/luarocks/fs/lua.lua
@@ -619,10 +619,5 @@ end
 -- @return boolean or (boolean, string): true on success, false on failure,
 -- plus an error message.
 function check_command_permissions(flags)
-   local root_dir = path.root_dir(cfg.rocks_dir)
-   if not flags["local"] and not (fs.is_writable(root_dir) or fs.is_writable(dir.dir_name(root_dir))) then
-      return nil, "Your user does not have write permissions in " .. root_dir ..
-                  " \n-- you may want to run as a privileged user or use your local tree with --local."
-   end
    return true
 end
