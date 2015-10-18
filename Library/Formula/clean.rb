class Clean < Formula
  desc "Search for files matching a regex and delete them"
  homepage "http://clean.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/clean/clean/3.4/clean-3.4.tar.bz2"
  sha256 "761f3a9e1ed50747b6a62a8113fa362a7cc74d359ac6e8e30ba6b30d59115320"

  def install
    system "make"
    bin.install "clean"
    man1.install "clean.1"
  end
end
