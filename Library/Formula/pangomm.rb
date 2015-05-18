class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage 'http://www.pango.org/'
  url "http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.36/pangomm-2.36.0.tar.xz"
  sha256 "a8d96952c708d7726bed260d693cece554f8f00e48b97cccfbf4f5690b6821f0"

  bottle do
    revision 1
    sha1 "f3eaeb1e10d6202cf2c705e218b603fb2823beb0" => :yosemite
    sha1 "999599894fce8a7bcbd3fb4f2e04e221c66b233e" => :mavericks
    sha1 "3df791891b37c582cad8712fe5a93d6c067ca90e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "cairomm"
  depends_on "pango"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
  end
end
