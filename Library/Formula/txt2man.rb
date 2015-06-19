class Txt2man < Formula
  desc "Convert flat ASCII text to man page format"
  homepage "http://mvertes.free.fr/"
  url "http://mvertes.free.fr/download/txt2man-1.5.6.tar.gz"
  sha1 "ef1392785333ea88f7e01f4f4c519ecfbdd498bd"

  depends_on "gawk"

  def install
    man1.install %w[bookman.1 src2man.1 txt2man.1]
    bin.install %w[bookman src2man txt2man]
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
