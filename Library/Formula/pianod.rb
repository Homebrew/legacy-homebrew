require "formula"

class Pianod < Formula
  homepage "http://deviousfish.com/pianod/"
  url "http://deviousfish.com/Downloads/pianod/pianod-165.tar.gz"
  sha1 "765efcf31f0e868538c81d03ae789df617d4c621"

  depends_on "pkg-config" => :build

  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "faad2" => :recommended
  depends_on "mad" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", '-v'
  end
end
