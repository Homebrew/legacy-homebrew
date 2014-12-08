require "formula"

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.10.33/node-v0.10.33.tar.gz"
  sha256 "75dc26c33144e6d0dc91cb0d68aaf0570ed0a7e4b0c35f3a7a726b500edd081e"
  revision 1

  bottle do
    revision 10
    sha1 "0b40240c1dd862f6eef91caa8f9ac2ebac43a489" => :yosemite
    sha1 "7445c2f31208ea044d14b917f6ad40c4cfe61970" => :mavericks
    sha1 "721ae41d459143c1e3f479533fcf342b196c673c" => :mountain_lion
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

  # Once we kill off SSLv3 in our OpenSSL consider forcing our OpenSSL
  # over Node's shipped version with --shared-openssl.
  # Would allow us quicker security fixes than Node's release schedule.
  # See https://github.com/joyent/node/issues/3557 for prior discussion.

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.1.11.tgz"
    sha1 "1eed4c04e4c8c745bc721baba1b4fe42f2af140c"
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

    # make sure npm can find node
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
