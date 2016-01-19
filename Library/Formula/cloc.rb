class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/1.64.tar.gz"
  sha256 "4ebac0ee3124df0c5394410f6803ed2b4f82de9035f62a0b89d8ce54e0726709"
  head "https://github.com/AlDanial/cloc.git"

  bottle :unneeded

  def install
    bin.install "cloc"
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
