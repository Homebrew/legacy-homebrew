class Sslsplit < Formula
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.4.11.tar.gz"
  sha256 "a33808f5d78000d1a919e61bbdfc48478ad40c1a9b09a0250b322f8954cc5ae0"

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    ENV.deparallelize
    inreplace "GNUmakefile", "-o 0 -g 0", "" # Remove UID 0,GID 0 setting for install
    system "make", "PREFIX=#{prefix}", "test"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sslsplit", "-V"
  end
end
