class Libguess < Formula
  desc "Character set guessing library"
  homepage "https://github.com/kaniini/libguess"
  url "https://github.com/kaniini/libguess.git", :revision => "b44a240c57ddce98f772ae7d9f2cf11a5972d8c2"
  version "1.2+20150609"
  head "https://github.com/kaniini/libguess.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      #include <libguess.h>

      int main(int argc, char **argv) {
        const char *buf = "안녕";
        printf("%s", libguess_determine_encoding(buf, strlen(buf), GUESS_REGION_KR));
        return (libguess_validate_utf8(buf, strlen(buf)) == 1) ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libguess", "-L#{lib}", "-lguess", "-o", "test"
    assert_match "UTF-8", shell_output("./test")
  end
end
