class Mpop < Formula
  desc "POP3 client"
  homepage "http://mpop.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpop/mpop/1.2.0/mpop-1.2.0.tar.xz"
  sha256 "9d28817a6950f64aadf10bf5841400701917102181ebf96c136fbd4707c17ba7"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
