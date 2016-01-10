class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "http://libwpd.sourceforge.net/"
  url "http://dev-www.libreoffice.org/src/libwpd-0.10.0.tar.bz2"
  sha256 "f2bf5d65156a351ce404550dd822c8db8ab8740b393f61dba828d1b2cb33fe91"

  bottle do
    cellar :any
    revision 1
    sha256 "05355b386219f540bd2e8072ff05d89bb8b0026ccc4ee19b57acbf00d1aba0ea" => :el_capitan
    sha256 "8e65b69dae039f3a08c5eb285871ded7b4fe1c7a503ad3bab1ab3811e8ed6ebc" => :yosemite
    sha256 "d372b1e93a6bbbf6c7bf767240da55cc12559bc79d6449a5b8a0bb05a728cc98" => :mavericks
    sha256 "7fe3f5acefc232f42b983928795d9cb9f40d5b03d52abfb1cac079e571bf689a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpd-0.10", "-I#{include}/libwpd-0.10"
    system "./test"
  end
end
