class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "http://deviousfish.com/pianod/"
  url "http://deviousfish.com/Downloads/pianod/pianod-175.tar.gz"
  sha256 "19733d4937b48707eebcde75775d865d6bf925efa86d8989f0efb2392ab4cdf9"

  bottle do
    sha256 "575f57442be94b8a182549015d58ea8066dde351f15ac91116647d5f6ef9425d" => :el_capitan
    sha256 "5537abdb08e7b78dce2d5b1d3cfa93bb2e525c9878214102cb34adea61f12ad8" => :yosemite
    sha256 "fd027eecd50b1ba82e048b2eb289219cddf068a93b849950fe690e44151c9540" => :mavericks
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
