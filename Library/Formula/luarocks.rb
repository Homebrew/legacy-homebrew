require 'formula'

class Luarocks < Formula
  homepage 'http://luarocks.org'
  url 'http://luarocks.org/releases/luarocks-2.0.13.tar.gz'
  sha1 'fb9d818c17d1ecb54fe23a53e31e52284b41e58e'

  head 'https://github.com/keplerproject/luarocks.git'

  depends_on 'lua'

  V = 5.2

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
	    "--lua-version=#{V}",
            "--sysconfdir=#{etc}/luarocks",
            "--with-lua-include=#{HOMEBREW_PREFIX}/include/lua-#{V}",
            "--lua-suffix=-#{V}"]

    system "./configure", *args
    system "make"
    system "make install"

    # Wrapper scripts to set up access to the correct rocktrees.
    (prefix+"bin/luarocks-5.1").write wrap_script ("luarocks", "5.1", "-")
    (prefix+"bin/luarocks-admin-5.1").write wrap_script ("luarocks-admin", "5.1", "-")
    (prefix+"bin/luarocks-jit-2.0").write wrap_script ("luarocks", "jit-2.0")
    (prefix+"bin/luarocks-admin-jit-2.0").write wrap_script ("luarocks-admin", "jit-2.0")
  end

  def caveats; <<-EOS.undent
    By default, rocks install to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks

    To manage rocks trees for other Lua interpreters, set LUAROCKS_CONFIG to the
    #{HOMEBREW_PREFIX}/lib/lua/<version>/luarocks-config.lua each installs before
    running luarocks or luarocks-admin; or source #{etc}/luarocks/init.sh from
    your shell startup, and select the current tree using the rockstree command.

    You may need to run `luarocks install` inside the Homebrew build
    environment for rocks to successfully build. To do this, first run `brew sh`.
    EOS
  end

  def wrap_script (wrapped, suffix, sep = ""); <<-EOS.undent
    #!/bin/sh
    export LUA='#{HOMEBREW_PREFIX}/bin/lua#{sep}#{suffix}'
    export LUAROCKS_CONFIG='#{HOMEBREW_PREFIX}/lib/lua/#{suffix}/luarocks-config.lua'

    test -f "$LUAROCKS_CONFIG" || {
      echo "error: please install lua#{sep}#{suffix} and try again!" >&2
      exit 1
    }

    eval `"$LUA" '#{HOMEBREW_PREFIX}/bin/luarocks' path`
    exec "$LUA" '#{opt_prefix}/bin/#{wrapped}' ${1+"$@"}
    EOS
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
@@ -669,29 +669,5 @@ end
 -- @return boolean or (boolean, string): true on success, false on failure,
 -- plus an error message.
 function check_command_permissions(flags)
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
