class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.6.0.tar.gz"
  sha256 "d6ed70ecf58a52130449a6dadbf7615514feeaf98f17034ff97772cbda6592d1"
  head "https://github.com/luvit/luvit.git"
  revision 1

  bottle do
    cellar :any
    sha256 "" => :yosemite
    sha256 "" => :mavericks
    sha256 "" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "openssl"

  def install
    ENV["USE_SYSTEM_SSL"] = "1"
    ENV["USE_SYSTEM_LUAJIT"] = "1"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    system bin/"luvit", "--cflags", "--libs"
  end
end
