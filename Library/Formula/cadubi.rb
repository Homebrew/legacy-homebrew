class Cadubi < Formula
  desc "Creative ASCII drawing utility"
  homepage "http://langworth.com/pub/cadubi/"
  url "https://github.com/statico/cadubi/releases/download/v1.3/cadubi-1.3.tar.gz"
  sha256 "ca8b6ea305e0eccb11add7fc165beeee7ef33f9f0106e84efa1b364f082df0ab"

  bottle :unneeded

  def install
    inreplace "cadubi", "$Bin/help.txt", "#{doc}/help.txt"
    bin.install "cadubi"
    doc.install "help.txt"
  end
end
