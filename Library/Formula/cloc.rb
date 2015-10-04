class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "http://cloc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cloc/cloc/v1.64/cloc-1.64.pl"
  sha256 "79edea7ea1f442b1632001e23418193ae4571810e60de8bd25e491036d60eb3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f595f12194d2f586ceb478638e8c5e3a8286cd602d1edf3e5e4ebceafe5ecc7" => :el_capitan
    sha256 "fd5ed31f8080c52f4db1f997e02173cc20f83adf671adcdac1cb42cc2c0e48fe" => :yosemite
    sha256 "56fc9b2baf7a18d1232640b0b6bdf2c0e63db11a27281504e13ce47684d253b3" => :mavericks
    sha256 "a4c159ceb7f5f67d7925864a8e4f31e2c43fe2dee356afdf931ebc1000ca11a3" => :mountain_lion
  end

  def install
    bin.install "cloc-#{version}.pl" => "cloc"
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
