class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.36/pangomm-2.36.0.tar.xz"
  sha256 "a8d96952c708d7726bed260d693cece554f8f00e48b97cccfbf4f5690b6821f0"

  bottle do
    cellar :any
    revision 3
    sha256 "9b8d8c0163bc79d5cd94081a92697bb2c9056306e2c51191b920185a5ad7891f" => :el_capitan
    sha256 "0c1411636ad8fe0c565ee82425ffbb2b7fe754902e8469f8536f8398b1bc9f7f" => :yosemite
    sha256 "e5c380347a09e75b6faa6fcda7883a5240cff4251b4221624e3767a6b93a959c" => :mavericks
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
