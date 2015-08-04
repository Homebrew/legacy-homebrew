class Sl < Formula
  desc "Prints a steam locomotive if you type sl instead of ls"
  homepage "https://github.com/mtoyoda/sl"
  url "https://github.com/mtoyoda/sl/archive/5.02.tar.gz"
  sha256 "1e5996757f879c81f202a18ad8e982195cf51c41727d3fea4af01fdcbbb5563a"

  head "https://github.com/mtoyoda/sl.git"

  fails_with :clang do
    build 318
  end

  def install
    system "make -e"
    bin.install "sl"
    man1.install "sl.1"
  end
end
