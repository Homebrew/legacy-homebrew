module Language
  module JS

    NPM_URL = "https://registry.npmjs.org/npm/-/npm-2.9.0.tgz"
    NPM_SHA256 = "a4d1434e934eaf08d985dbe3b70e0d456fb6866828afc91e99b3aac286fca055"

    def install_npm(path)
      # make sure npm can find node
      ENV.prepend_path "PATH", bin
      # make sure user prefix settings in $HOME are ignored
      ENV["HOME"] = buildpath/"home"
      # set log level temporarily for npm's `make install`
      ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"

      cd path do
        system "./configure", "--prefix=#{libexec}/npm"
        system "make", "install"
      end
    end

    def install_npm_bash_completion (path)
      bash_completion.install \
          path/"lib/utils/completion.sh" => "npm"
    end

    def npm_post_install(libexec)
      node_modules = HOMEBREW_PREFIX/"lib/node_modules"
      node_modules.mkpath
      npm_exec = node_modules/"npm/bin/npm-cli.js"
      # Kill npm but preserve all other modules across node updates/upgrades.
      rm_rf node_modules/"npm"

      cp_r libexec/"npm/lib/node_modules/npm", node_modules
      # This symlink doesn't hop into homebrew_prefix/bin automatically so
      # remove it and make our own. This is a small consequence of our bottle
      # npm make install workaround. All other installs **do** symlink to
      # homebrew_prefix/bin correctly. We ln rather than cp this because doing
      # so mimics npm's normal install.
      ln_sf npm_exec, "#{HOMEBREW_PREFIX}/bin/npm"

      # Let's do the manpage dance. It's just a jump to the left.
      # And then a step to the right, with your hand on rm_f.
      ["man1", "man3", "man5", "man7"].each do |man|
        # Dirs must exist first: https://github.com/Homebrew/homebrew/issues/35969
        mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
        rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.}*"]
        ln_sf Dir[libexec/"npm/share/man/#{man}/npm*"], HOMEBREW_PREFIX/"share/man/#{man}"
      end

      npm_root = node_modules/"npm"
      npmrc = npm_root/"npmrc"
      npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
    end

    def npm_caveats
      s = ""

      if build.without? "npm"
        s += <<-EOS.undent
          Homebrew has NOT installed npm. If you later install it, you should supplement
          your NODE_PATH with the npm module folder:
            #{HOMEBREW_PREFIX}/lib/node_modules
        EOS
      else
        s += <<-EOS.undent
          npm has been installed. To update run
            npm install -g npm@latest

          You can install global npm packages with
            npm install -g <package>

          Packages will install into the global node_modiles directory
            #{HOMEBREW_PREFIX}/lib/node_modules
        EOS
      end
      return s
    end

    def npm_test_install
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
      # Test if node-gyp is working by building a native addon
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "buffertools"
    end
  end
end
