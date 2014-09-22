require 'formula'

class Luarocks < Formula
  homepage "http://luarocks.org"

  stable do
    url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
    sha1 "e2de00f070d66880f3766173019c53a23229193d"

    # Remove writability checks in the install script.
    # Homebrew checks that its install targets are writable, or fails with
    # appropriate messaging if not. The check that luarocks does has been
    # seen to have false positives, so remove it.
    # TODO: better document the false positive cases, or remove this patch.
    patch :DATA
  end

  head "https://github.com/keplerproject/luarocks.git"

  depends_on 'lua'

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--lua-version=5.2",
            "--sysconfdir=#{etc}/luarocks"]

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Rocks install to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks

    You may need to run `luarocks install` inside the Homebrew build
    environment for rocks to successfully build. To do this, first run `brew sh`.
    EOS
  end

  test do
    opoo "Luarocks test script installs 'lpeg'"
    system "#{bin}/luarocks", "install", "lpeg"
    system "lua", "-llpeg", "-e", 'print ("Hello World!")'
  end
end

__END__
diff --git a/src/luarocks/fs/lua.lua b/src/luarocks/fs/lua.lua
index b261905..f396030 100644
--- a/src/luarocks/fs/lua.lua
+++ b/src/luarocks/fs/lua.lua
@@ -791,31 +791,7 @@ end
 -- @return boolean or (boolean, string): true on success, false on failure,
 -- plus an error message.
 function fs_lua.check_command_permissions(flags)
-   local root_dir = path.root_dir(cfg.rocks_dir)
-   local ok = true
-   local err = ""
-   for _, dir in ipairs { cfg.rocks_dir, root_dir } do
-      if fs.exists(dir) and not fs.is_writable(dir) then
-         ok = false
-         err = "Your user does not have write permissions in " .. dir
-         break
-      end
-   end
-   local root_parent = dir.dir_name(root_dir)
-   if ok and not fs.exists(root_dir) and not fs.is_writable(root_parent) then
-      ok = false
-      err = root_dir.." does not exist and your user does not have write permissions in " .. root_parent
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
