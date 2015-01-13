class Deheader < Formula
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.0.tar.gz"
  sha1 "dc9fc816af1631a84ace7f94a85a3a424d72dbed"
  head "https://git.gitorious.org/deheader/deheader.git"

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
    assert_equal "121", shell_output("deheader test.c | tr -cd 0-9")
  end
end
