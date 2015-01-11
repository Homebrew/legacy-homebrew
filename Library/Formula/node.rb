# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.10.35/node-v0.10.35.tar.gz"
  sha256 "0043656bb1724cb09dbdc960a2fd6ee37d3badb2f9c75562b2d11235daa40a03"
  bottle do
    sha1 "8fd61f7a0c6307a44b150fd81939bbf7c69216c9" => :yosemite
    sha1 "c4866999f23fbfdf1e80d7bf0ddd04c338985c51" => :mavericks
    sha1 "8b07a08623662ecf73d6f228d7b31cb854ead449" => :mountain_lion
  end

  revision 2

  head do
    url "https://github.com/joyent/node.git", :branch => "v0.12"

    depends_on "pkg-config" => :build
    depends_on "icu4c"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  depends_on :python => :build

  # Once we kill off SSLv3 in our OpenSSL consider forcing our OpenSSL
  # over Node's shipped version with --shared-openssl.
  # Would allow us quicker security fixes than Node's release schedule.
  # See https://github.com/joyent/node/issues/3557 for prior discussion.

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
    args << "--without-ssl2" << "--without-ssl3" if build.stable?

    # This should eventually be able to use the system icu4c, but right now
    # it expects to find this dependency using pkgconfig.
    if build.head?
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].opt_prefix}/lib/pkgconfig"
      args << "--with-intl=system-icu"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage libexec/"npm_i"

      # make sure npm can find node
      ENV["PATH"] = "#{Formula["node"].prefix}/bin:#{ENV["PATH"]}"

      # set log level temporarily for npm's `make install`
      ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"

      (libexec/"npm_i").cd { system "./configure", "--prefix=#{libexec}/npm" }
      (libexec/"npm_i").cd { system "make", "install" }

      # Manpages aren't currently linking, which is frustrating.
      # FIXTHIS before merge, ideally.
      rm_rf libexec/"npm/lib/node_modules/npm/share"

      if build.with? "completion"
        bash_completion.install \
          libexec/"npm_i/lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    npm_exec = node_modules/"npm/bin/npm-cli.js"
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm" if (node_modules/"npm").exist?

    cp_r libexec/"npm/lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin
    # automatically so remove it and make our own.
    # This is a small consequence of our bottle npm make install workaround.
    # All other installs **do** symlink to homebrew_prefix/bin correctly.
    # We ln rather than cp this because doing so mimics npm's normal install.
    ln_sf npm_exec, "#{HOMEBREW_PREFIX}/bin/npm"

    npm_root = node_modules/"npm"

    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")

    rm_rf libexec

    ENV["NPM_CONFIG_USERCONFIG"] = npmrc
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
