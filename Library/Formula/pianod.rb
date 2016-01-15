class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "http://deviousfish.com/pianod/"
  url "http://deviousfish.com/Downloads/pianod/pianod-173.tar.gz"
  sha256 "d91a890561037ee3faf5d4d1d4de546c8ff8c828eced91eea6be026c4fcf16fd"
  revision 1

  devel do
    url "http://deviousfish.com/Downloads/pianod/pianod-174.tar.gz"
    sha256 "8b46cf57a785256bb9d5543022c1b630a5d45580800b6eb6c170712c6c78d879"
  end

  bottle do
    sha256 "575f57442be94b8a182549015d58ea8066dde351f15ac91116647d5f6ef9425d" => :el_capitan
    sha256 "5537abdb08e7b78dce2d5b1d3cfa93bb2e525c9878214102cb34adea61f12ad8" => :yosemite
    sha256 "fd027eecd50b1ba82e048b2eb289219cddf068a93b849950fe690e44151c9540" => :mavericks
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
    system "#{bin}/pianod", "-v"
  end
end
