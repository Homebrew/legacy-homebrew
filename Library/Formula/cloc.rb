class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/v1.66.tar.gz"
  sha256 "6d8b5e9fac8934478a0fd815f60d814b93d4a12344c4820f5b47a55048b21d53"
  head "https://github.com/AlDanial/cloc.git"

  def install
    system "make", "-C", "Unix", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
