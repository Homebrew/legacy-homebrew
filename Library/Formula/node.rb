# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.10.35/node-v0.10.35.tar.gz"
  sha256 "0043656bb1724cb09dbdc960a2fd6ee37d3badb2f9c75562b2d11235daa40a03"
  revision 2

  bottle do
    revision 2
    sha1 "47488bdb1f2454429d6a080c22e6e2c4cfe1f339" => :yosemite
    sha1 "fbb207787027eceda84ac05cd40f6b0b733b3aef" => :mavericks
    sha1 "d72f12249dbb91a9e882d29dd0585ff623ae8769" => :mountain_lion
  end

  devel do
    url "https://nodejs.org/dist/v0.11.15/node-v0.11.15.tar.gz"
    sha256 "e613d274baa4c99a0518038192491433f7877493a66d8505af263f6310991d01"

    depends_on "pkg-config" => :build
    depends_on "icu4c" => :optional
    depends_on "openssl" => :optional
  end

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

  # Once we kill off SSLv3 in our OpenSSL consider making our OpenSSL
  # an optional dep across the whole range of Node releases.

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.3.0.tgz"
    sha1 "3588ec5c18fb5ac41e5721b0ea8ece3a85ab8b4b"
  end

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--without-ssl2" << "--without-ssl3" if build.stable?

    if build.head?
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].opt_lib}/pkgconfig"
      args << "--with-intl=system-icu"
    end

    if build.devel?
      if build.with? "icu4c"
        ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].opt_lib}/pkgconfig"
        args << "--with-intl=system-icu"
      end

      if build.with? "openssl"
        args << "--shared-openssl"
      else
        args << "--without-ssl2" << "--without-ssl3"
      end
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage buildpath/"npm_install"

      # make sure npm can find node
      ENV.prepend_path "PATH", bin

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
      ln_sf Dir[libexec/"npm/share/man/#{man}/npm*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
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
