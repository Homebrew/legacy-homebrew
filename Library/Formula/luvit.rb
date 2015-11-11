class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.6.0.tar.gz"
  sha256 "d6ed70ecf58a52130449a6dadbf7615514feeaf98f17034ff97772cbda6592d1"
  head "https://github.com/luvit/luvit.git"
  

  bottle do
    cellar :any
    sha256 "3c7250314f67d320d8bc36f14e8d055860a2098bf5528b53eb58ff7d93244881" => :yosemite
    sha256 "1f4616aa1be7802088900bcec2f284e8a85a4b82ee6fc9873a4c20d30ac6ac47" => :mavericks
    sha256 "ef23e4e0cf252074738d85b1b2b2e02fd58e3a5239e00362d6f1e4dc2c58862c" => :mountain_lion
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
