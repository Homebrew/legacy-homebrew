class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "http://libspectre.freedesktop.org/releases/libspectre-0.2.7.tar.gz"
  sha256 "e81b822a106beed14cf0fec70f1b890c690c2ffa150fa2eee41dc26518a6c3ec"

  bottle do
    cellar :any
    sha256 "7f81fd034a403e3460b589e0d1b3ee49f45baca81fc287b3f3abb7517a56cc5f" => :yosemite
    sha256 "d5978d2bd2eeae441bdd64d6d96066c85ffd0a7006a955c0e84646e75d9b1767" => :mavericks
    sha256 "32ad21d70cf7d08dbc3fd6158002f2c102a684c8d61993962db3a94d0bfa8394" => :mountain_lion
  end

  depends_on "ghostscript"

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
