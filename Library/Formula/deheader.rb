require 'formula'

class Deheader < Formula
  homepage 'http://www.catb.org/~esr/deheader'
  url 'http://www.catb.org/~esr/deheader/deheader-0.8.tar.gz'
  sha1 '4527b4675a7b06d728cfa989a3b7844cdf091b40'
  head 'https://git.gitorious.org/deheader/deheader.git'

  def install
    bin.install "deheader"
    man1.install "deheader.1"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    EOS
    assert_equal "121", `deheader test.c | tr -cd 0-9`
  end
end
