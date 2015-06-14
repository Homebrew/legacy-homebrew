class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.1.tar.gz"
  sha256 "69f69e9c7d9398221cb49f7de91df0d122e4b0ec942bede2d7c592401e4b913c"
  head "git://thyrsus.com/repositories/deheader.git"

  def install
    bin.install "deheader"
    # Man page is defined in a DocBook XML file, the DTD for which is MIA,
    # thus there's no way to build it from HEAD...
    man1.install "deheader.1" unless build.head?
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
