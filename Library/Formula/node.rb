require "formula"

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "http://nodejs.org/"
  url "http://nodejs.org/dist/v0.10.32/node-v0.10.32.tar.gz"
  sha1 "1d748171ba2a9568853ccec442c5f62c46fccc20"

  bottle do
    revision 3
    sha1 "42d3400b26a5c75c9474d82e4a87ad7befdc14c3" => :mavericks
    sha1 "718aa836d684e2590d58d7a424af5811bd015ee5" => :mountain_lion
    sha1 "9bef3cd554caa933de28cd22ee743daeffb3df21" => :lion
  end

  head "https://github.com/joyent/node.git"

  option "enable-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  depends_on :python => :build

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-1.4.24.tgz"
    sha1 "78125bb55dc592b9cbf4aff44e33d5d81c9471af"
  end

  def install
    args = %W{--prefix=#{prefix} --without-npm}
    args << "--debug" if build.include? "enable-debug"

    system "./configure", *args
    system "make", "install"

    resource("npm").stage libexec/"npm" if build.with? "npm"
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    cp_r libexec/"npm", node_modules

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")

    ENV["NPM_CONFIG_USERCONFIG"] = npmrc
    npm_root.cd { system "make", "install" }
    system "#{HOMEBREW_PREFIX}/bin/npm", "install", "--global", "npm@latest",
                                         "--prefix", HOMEBREW_PREFIX

    Pathname.glob(npm_root/"man/*") do |man|
      man.children.each do |file|
        ln_sf file, "#{HOMEBREW_PREFIX}/share/man/#{man.basename}"
      end
    end

    if build.with? "completion"
      bash_completion.install_symlink \
        npm_root/"lib/utils/completion.sh" => "npm"
    end
  end

  def caveats
    if build.without? "npm"; <<-end.undent
      Homebrew has NOT installed npm. If you later install it, you should supplement
      your NODE_PATH with the npm module folder:
        #{HOMEBREW_PREFIX}/lib/node_modules
      end
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/node #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus

    system "#{HOMEBREW_PREFIX}/bin/npm", "install", "npm@latest" if build.with? "npm"
  end
end
