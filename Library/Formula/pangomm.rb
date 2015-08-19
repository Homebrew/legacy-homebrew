class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.36/pangomm-2.36.0.tar.xz"
  sha256 "a8d96952c708d7726bed260d693cece554f8f00e48b97cccfbf4f5690b6821f0"

  bottle do
    revision 2
    sha256 "a4afe1689018acaaf90188aacfc58bc693d452435eac454862119f7c65ad57d7" => :yosemite
    sha256 "5cba5979e9baccba789485d6836143a506fed4fa9b7b6e1ebeaead0702e6b0c0" => :mavericks
    sha256 "a3cb0498a296caf02bcff369c7b81c2145d0e7efd140ed4d604f9a6d159c9bf2" => :mountain_lion
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
