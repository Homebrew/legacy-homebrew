require "formula"

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "http://nodejs.org/"
  url "http://nodejs.org/dist/v0.10.33/node-v0.10.33.tar.gz"
  sha256 "75dc26c33144e6d0dc91cb0d68aaf0570ed0a7e4b0c35f3a7a726b500edd081e"

  bottle do
    revision 6
    sha1 "4a28432c960e5eac419d304b927c1f2c55aa2bda" => :yosemite
    sha1 "169ef2c3d46e42f79d07c52b293f4e2a4e16eb2b" => :mavericks
    sha1 "901b0d05921eb0fcaea3e2329d9d01792db156bc" => :mountain_lion
  end

  devel do
    url "http://nodejs.org/dist/v0.11.14/node-v0.11.14.tar.gz"
    sha256 "ce08b0a2769bcc135ca25639c9d411a038e93e0f5f5a83000ecde9b763c4dd83"
  end

  head "https://github.com/joyent/node.git"

  option "enable-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  depends_on :python => :build

  # Once we kill off SSLv3 in our OpenSSL consider forcing our OpenSSL
  # over Node's shipped version with --shared-openssl.
  # Would allow us quicker security fixes than Node's release schedule.

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.1.6.tgz"
    sha1 "a28e8b44f910b9ab056aa0b73c13c1f9459c9b37"
  end

  def install
    args = %W{--prefix=#{prefix} --without-npm}
    args << "--debug" if build.include? "enable-debug"
    args << "--without-ssl2" << "--without-ssl3" if build.stable?

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
        If you update npm do NOT use the npm upgrade command
        Instead execute:
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
