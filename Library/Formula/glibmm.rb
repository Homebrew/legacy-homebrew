class Glibmm < Formula
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.44/glibmm-2.44.0.tar.xz"
  sha256 "1b0ac0425d24895507c0e0e8088a464c7ae2d289c47afa1c11f63278fc672ea8"

  bottle do
    sha256 "441a1090b234db948a47ca1996dfab13c9d28d7ddbee74611ffd443c6088dca6" => :yosemite
    sha256 "dc82204feb11ee31c04500c5a2327a42db838fb7e9c8ceeb0b9f0eb605dbaa76" => :mavericks
    sha256 "53810b3d4d76b685fc9195be3162d73f973dea0596f3630724f3af049830458a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    system ENV.cxx, "-I#{HOMEBREW_PREFIX}/include/glibmm-2.4", "-I#{HOMEBREW_PREFIX}/lib/glibmm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I#{HOMEBREW_PREFIX}/include/sigc++-2.0", "-I#{HOMEBREW_PREFIX}/lib/sigc++-2.0/include", "test.cpp", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-L#{HOMEBREW_PREFIX}/lib", "-lglibmm-2.4", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-lsigc-2.0", "-o", "test"
    system "./test"
  end
end
