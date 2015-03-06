class Luvit < Formula
  homepage "https://luvit.io"
  url "https://luvit.io/dist/latest/luvit-0.8.2.tar.gz"
  sha256 "c2639348d1716c38ac3cd66ea4c4ff1c8a72f4610dbd6e50cf31426d3956c5ff"
  head "https://github.com/luvit/luvit.git"
  revision 1

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
