class Ploticus242 < Formula
  desc "ploticus data display package"
  homepage "http://ploticus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ploticus/ploticus/2.42/ploticus242_src.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fploticus%2F%3Fsource%3Dtyp_redirect&ts=1449655936"
  version "2.42"
  sha256 "3f29e4b9f405203a93efec900e5816d9e1b4381821881e241c08cab7dd66e0b0"

  depends_on "libpng"

  def install
    system "make", "-C", "src"
    bin.install "src/pl"
  end

  test do
    system "pl 2>&1 >/dev/null | grep 'usage: pl scriptfile'"
  end
end
