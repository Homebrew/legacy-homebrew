class Jcal < Formula
  desc "UNIX-cal-like tool to display Jalali calendar"
  homepage "http://savannah.nongnu.org/projects/jcal/"
  url "http://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz"
  sha256 "e8983ecad029b1007edc98458ad13cd9aa263d4d1cf44a97e0a69ff778900caa"

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
