class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "http://deviousfish.com/pianod/"
  url "http://deviousfish.com/Downloads/pianod/pianod-175.tar.gz"
  sha256 "19733d4937b48707eebcde75775d865d6bf925efa86d8989f0efb2392ab4cdf9"

  bottle do
    sha256 "2ee0ba99862d32947b418b00ea3d1f6bab6bbbfbe5a9cd190558e3baf4c0586b" => :el_capitan
    sha256 "535664f3192932537dc9656380e44fa8c1e835ba361e6f92418cd379e6970d0d" => :yosemite
    sha256 "33d938cf80c04f224f72bca2592a20b28707246c5c5450baaf1974e4114e8bfc" => :mavericks
  end

  devel do
    url "http://deviousfish.com/Downloads/pianod2/Devel/pianod2-189.tar.gz"
    sha256 "dad7a1a5b18a712178d3835ef2cd898f0f92a8d608987bdfc807ce2226fab863"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => :build if build.devel?

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
    system "#{bin}/pianod", "-v"
  end
end
