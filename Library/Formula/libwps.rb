require "formula"

class Libwps < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://dev-www.libreoffice.org/src/libwps-0.3.0.tar.bz2'
  sha1 '526323bd59b5f59f8533882fb455e5886bf1f6dc'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build
  depends_on 'libwpd'
  depends_on 'librevenge'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
  (testpath/'test.cpp').write <<-EOS.undent
    #include <libwps/libwps.h>
    int main() {
      return libwps::WPS_OK;
    }
  EOS
  system ENV.cc, "test.cpp",
                 "-lrevenge-0.0", "-I#{Formula['librevenge'].include}/librevenge-0.0",
                 "-lwpd-0.10", "-I#{Formula['libwpd'].include}/libwpd-0.10",
                 "-lwps-0.3", "-I#{include}/libwps-0.3"
  end
end
