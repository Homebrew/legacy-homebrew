class Sic < Formula
  desc "Minimal multiplexing IRC client"
  homepage "http://tools.suckless.org/sic"
  url "http://dl.suckless.org/tools/sic-1.2.tar.gz"
  sha256 "ac07f905995e13ba2c43912d7a035fbbe78a628d7ba1c256f4ca1372fb565185"

  head "http://git.suckless.org/sic", :using => :git

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
