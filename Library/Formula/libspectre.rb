class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "http://libspectre.freedesktop.org/releases/libspectre-0.2.7.tar.gz"
  sha256 "e81b822a106beed14cf0fec70f1b890c690c2ffa150fa2eee41dc26518a6c3ec"
  revision 1

  bottle do
    cellar :any
    sha256 "1b5b24594a653e6446f7011634690dc89c863896ee9624566b53e154a8ac6c95" => :el_capitan
    sha256 "1631717eab696f98d23822ddc7053b4e0584ed48ddaae64bd8701e59d6460e3e" => :yosemite
    sha256 "301b2330d47b35c62ca00c8cac43957367d7fc8101ba68a10e91f03271ebdc0a" => :mavericks
  end

  depends_on "ghostscript"

  patch do
    url "https://github.com/Homebrew/patches/raw/master/libspectre/libspectre-0.2.7-gs918.patch"
    sha256 "e4c186ddc6cebc92ee0aee24bc79c7f5fff147a0c0d9cadf7ebdc3906d44711c"
  end

  def install
    ENV.append "CFLAGS", "-I#{Formula["ghostscript"].opt_include}/ghostscript"
    ENV.append "LIBS", "-L#{Formula["ghostscript"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libspectre/spectre.h>

      int main(int argc, char *argv[]) {
        const char *text = spectre_status_to_string(SPECTRE_STATUS_SUCCESS);
        return 0;
      }
    EOS
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
