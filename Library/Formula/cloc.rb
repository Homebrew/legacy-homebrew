class Cloc < Formula
  homepage "http://cloc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cloc/cloc/v1.62/cloc-1.62.pl"
  sha256 "fa3793b576895cde2acae26a49447bf0c55ab3f79bdacfb00a88fc1d255c2570"

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
