class Txt2man < Formula
  desc "Convert flat ASCII text to man page format"
  homepage "https://github.com/mvertes/txt2man"
  url "https://github.com/mvertes/txt2man/archive/txt2man-1.5.6.tar.gz"
  sha256 "df9d972c6930576328b779e64aed6d3e0106118e5a4069172f06db290f32586a"
  head "https://github.com/mvertes/txt2man.git"

  depends_on "gawk"

  def install
    inreplace "Makefile", "$(prefix)/man/man1", man1
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    # txt2man
    (testpath/"test.txt").write <<-EOS.undent
      A TITLE

      blah blah blah
    EOS

    assert_match(/\.SH A TITLE/, shell_output("#{bin}/txt2man test.txt"))

    # src2man
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>

      /** 3
      * main - do stuff
      **/
      int main(void) { return 0; }
    EOS

    assert_equal "main.3\n", shell_output("#{bin}/src2man test.c 2>&1")
    assert File.read("main.3").include?(%q(\fBmain \fP- do stuff))

    # bookman
    system "#{bin}/bookman", "-t", "Test", "-o", "test", Dir["#{man1}/*"]
    assert File.exist?("test")
  end
end
