require "formula"

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "http://nodejs.org/"
  url "http://nodejs.org/dist/v0.10.32/node-v0.10.32.tar.gz"
  sha256 "c2120d0e3d2d191654cb11dbc0a33a7216d53732173317681da9502be0030f10"

  bottle do
    sha1 "f9f083a1cf13cf3703c764d639702627968e2234" => :mavericks
    sha1 "83a01d1079ed1bc02a7c9fc7cefa589027778b15" => :mountain_lion
    sha1 "a2dbe4a3358e98813fbc6c83cfa79120177e6fc8" => :lion
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
