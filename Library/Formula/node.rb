# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.12.2/node-v0.12.2.tar.gz"
  sha256 "ac7e78ade93e633e7ed628532bb8e650caba0c9c33af33581957f3382e2a772d"
  head "https://github.com/joyent/node.git", :branch => "v0.12"
  revision 1

  bottle do
    revision 1
    sha256 "8c5151f74f57f106a94cbfaa910b28bd089edaf3690b5c9d77ed2de0941af605" => :yosemite
    sha256 "3c96ca9675bd6b11411a1256c605ff9d0e8366817a2426fc762a3fea21876e9b" => :mavericks
    sha256 "6a2582a5d5d3613cee4219331f10585c3a066b80c1e31b617a9cc1368d53b4d7" => :mountain_lion
  end

  option "with-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  deprecated_option "enable-debug" => "with-debug"

  depends_on :python => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  # https://github.com/joyent/node/issues/7919
  # https://github.com/Homebrew/homebrew/issues/36681
  depends_on "icu4c" => :optional

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.10.0.tgz"
    sha256 "c85b990fd63c4c60a5fcf54deff500438e2918f0b2b010d1ca62d94f29af0d3a"
  end

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"

    if build.with? "openssl"
      args << "--shared-openssl"
    else
      args << "--without-ssl2" << "--without-ssl3"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage buildpath/"npm_install"

      # make sure npm can find node
      ENV.prepend_path "PATH", bin
      # make sure user prefix settings in $HOME are ignored
      ENV["HOME"] = buildpath/"home"
      # set log level temporarily for npm's `make install`
      ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"

      cd buildpath/"npm_install" do
        system "./configure", "--prefix=#{libexec}/npm"
        system "make", "install"
      end

      if build.with? "completion"
        bash_completion.install \
          buildpath/"npm_install/lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

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
      ln_sf Dir[libexec/"npm/lib/node_modules/npm/man/#{man}/npm*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    s = ""

    if build.without? "npm"
      s += <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    if build.with? "icu4c"
      s += <<-EOS.undent

        Please note `icu4c` is built with a newer deployment target than Node and
        this may cause issues in certain usage. Node itself is built against the
        outdated `libstdc++` target, which is the root cause. For more information see:
          https://github.com/joyent/node/issues/7919

        If this is an issue for you, do `brew install node --without-icu4c`.
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/node #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      assert_equal which("node"), opt_bin/"node"
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
    end
  end
end
