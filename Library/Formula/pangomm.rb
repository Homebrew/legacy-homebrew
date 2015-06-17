class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage 'http://www.pango.org/'
  url "https://download.gnome.org/sources/pangomm/2.36/pangomm-2.36.0.tar.xz"
  sha256 "a8d96952c708d7726bed260d693cece554f8f00e48b97cccfbf4f5690b6821f0"

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
