class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.0.0/iojs-v1.0.0.tar.gz"
  sha256 "dcc6ccd99fffa20ebe59b35acca51150cfd68171cbf36fee210b3f5480964d05"
  revision 1

  head do
    url "https://github.com/iojs/io.js.git", :branch => "v1.x"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  depends_on :python => :build

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.1.18.tgz"
    sha1 "e2af4c5f848fb023851cd2ec129005d33090bd57"
  end

  def install
    args = %W{--prefix=#{prefix} --without-npm}
    args << "--debug" if build.with? "debug"

    system "./configure", *args
    system "make", "install"

    resource("npm").stage libexec/"npm" if build.with? "npm"
  end

  def post_install
    return if build.without? "npm"

    (libexec/"npm").cd { system "make", "uninstall" }
    Pathname.glob(HOMEBREW_PREFIX/"share/man/*") do |man|
      next unless man.directory?
      man.children.each do |file|
        next unless file.symlink?
        file.unlink if file.readlink.to_s.include? "/node_modules/npm/man/"
      end
    end

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    cp_r libexec/"npm", node_modules

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")

    # set log level temporarily for npm's `make install`
    ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"

    # make sure npm can find iojs
    ENV["PATH"] = "#{opt_bin}:#{ENV["PATH"]}"

    ENV["NPM_CONFIG_USERCONFIG"] = npmrc
    npm_root.cd { system "make", "install" }

    if build.with? "completion"
      bash_completion.install_symlink \
        npm_root/"lib/utils/completion.sh" => "npm"
    end
  end

  def caveats
    s = ""

    if build.with? "npm"
      s += <<-EOS.undent
        If you update npm itself, do NOT use the npm update command.
        The upstream-recommended way to update npm is:
          npm install -g npm@latest
      EOS
    else
      s += <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/iojs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus

    if build.with? "npm"
      # make sure npm can find iojs
      ENV.prepend_path "PATH", opt_bin
      assert_equal which("iojs"), opt_bin/"iojs"
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
    end
  end
end
