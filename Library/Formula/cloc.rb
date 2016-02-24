class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/v1.66.tar.gz"
  sha256 "6d8b5e9fac8934478a0fd815f60d814b93d4a12344c4820f5b47a55048b21d53"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c140cd2b7244b48e45971130d69ffa3a250d7fda4885098b6a01a33fb3bc4ef1" => :el_capitan
    sha256 "4abbd7aec11e52eac56a1ab969a3825ff162f7d19598b94c02116dc01ad18e43" => :yosemite
    sha256 "994e73fb9afde00c2f3fde26a9421707bf73ce85de6d7021d4db2819307fbd48" => :mavericks
  end

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
