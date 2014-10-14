require "formula"

class Pianod < Formula
  homepage "http://deviousfish.com/pianod/"
  url "http://deviousfish.com/Downloads/pianod/pianod-165.tar.gz"
  sha1 "765efcf31f0e868538c81d03ae789df617d4c621"

  bottle do
    sha1 "f2630bf3374fff4bd2f9361dc6b6a9dbdb8e91b2" => :mavericks
    sha1 "8edad71c88e41febb6a948389359e9b3f8f8d043" => :mountain_lion
    sha1 "9675d746fb9ee4d1e66cd0b62a1563d683850a4d" => :lion
  end

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
