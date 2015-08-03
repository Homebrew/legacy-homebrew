class Gaffitter < Formula
  desc "Efficiently fit files/folders to fixed size volumes (like DVDs)"
  homepage "http://gaffitter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gaffitter/gaffitter/0.6.0/gaffitter-0.6.0.tar.bz2"
  sha256 "61236240942d0319fb1c0a7e3da8424ddad7fe5abc82c2e1e3f2a89ccc9fe275"

  def install
    system "make"
    bin.install "src/gaffitter"
  end
end
