class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "http://cloc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cloc/cloc/v1.62/cloc-1.62.pl"
  sha1 "78f6123c967f9b142f77cba48decd11d56ab6c38"

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
