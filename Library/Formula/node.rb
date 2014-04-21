require 'formula'

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.10.26/node-v0.10.26.tar.gz'
  sha1 '2340ec2dce1794f1ca1c685b56840dd515a271b2'

  bottle do
    sha1 "0db92b18d10cb7505d7c885058e337aeb5e9741c" => :mavericks
    sha1 "b48b83e92cdb8b064620c7fef409b37a2ae90e67" => :mountain_lion
    sha1 "ecd7b384658ad1a54a74174d07dcffc3aa5ddc92" => :lion
  end

  devel do
    url 'http://nodejs.org/dist/v0.11.12/node-v0.11.12.tar.gz'
    sha1 'd991057af05dd70feb2126469ce279a2fe869e86'
  end

  head 'https://github.com/joyent/node.git'

  option 'enable-debug', 'Build with debugger hooks'
  option 'without-npm', 'npm will not be installed'
  option 'without-completion', 'npm bash completion will not be installed'

  depends_on :python => :build

  fails_with :llvm do
    build 2326
  end

  resource "npm" do
    url "http://registry.npmjs.org/npm/-/npm-1.4.6.tgz"
    sha1 "0e151bce38e72cf2206a6299fa5164123f04256e"
  end

  def install
    args = %W{--prefix=#{prefix} --without-npm}
    args << "--debug" if build.include? 'enable-debug'

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

    npm_root.cd { system "make", "install" }
    system "#{HOMEBREW_PREFIX}/bin/npm", "update", "npm", "-g"

    Pathname.glob(npm_root/"man/*") do |man|
      dir = send(man.basename)
      man.children.each do |file|
        dir.install_symlink(file)
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

    system "#{HOMEBREW_PREFIX}/bin/npm", "install", "npm" if build.with? "npm"
  end
end
