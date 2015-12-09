class Jcal < Formula
  desc "UNIX-cal-like tool to display Jalali calendar"
  homepage "https://savannah.nongnu.org/projects/jcal/"
  url "http://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz"
  sha256 "e8983ecad029b1007edc98458ad13cd9aa263d4d1cf44a97e0a69ff778900caa"

  bottle do
    cellar :any
    sha256 "4d876e18cb50c7aa31211b60b66e42637ca3c9eeed9c688c1945dc4755977597" => :el_capitan
    sha256 "3640b058b034b519a5aa3bb1dde36b4efb2ec7bb8124bdbd106617202bf87b22" => :yosemite
    sha256 "f3c61ee0a88644c66be60de5d0d0c3ec0118aa4762797baab398363c948a0536" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jcal", "-y"
    system "#{bin}/jdate"
  end
end
