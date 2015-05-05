require "language/javascript"

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  include Language::JS

  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.12.2/node-v0.12.2.tar.gz"
  sha256 "ac7e78ade93e633e7ed628532bb8e650caba0c9c33af33581957f3382e2a772d"
  head "https://github.com/joyent/node.git", :branch => "v0.12"
  revision 1

  bottle do
    sha256 "6fa67abcaf006fd9fd749267f08d5e8c33cb7eadd6e94267a49e96659256b06a" => :yosemite
    sha256 "a995d265c9db0b021de140cdcc78432b96bcbf3fdb6989cc401d9cd7c2164cdd" => :mavericks
    sha256 "cde73f7ca5b2c080bb8e7d5b99fa02ac43908ec8ad24ef52d9a3a44141ffbe75" => :mountain_lion
  end

  conflicts_with "iojs", :because => "node and iojs both install a binary/link named node"

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
    url Language::JS::NPM_URL
    sha256 Language::JS::NPM_SHA256
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
      resource("npm").stage npm_buildpath = buildpath/"npm_install"
      install_npm npm_buildpath

      if build.with? "completion"
        install_npm_bash_completion npm_buildpath
      end
    end
  end

  def post_install
    return if build.without? "npm"

    npm_post_install libexec
  end

  def caveats
    s = ""

    s += npm_caveats

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
      npm_test_install
    end
  end
end
