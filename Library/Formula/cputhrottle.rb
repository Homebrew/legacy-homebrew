require "formula"

class Cputhrottle < Formula
  homepage "http://www.willnolan.com/cputhrottle/cputhrottle.html"
  url "http://www.willnolan.com/cputhrottle/cputhrottle.tar.gz"
  sha1 "e88c7264cb09399f2e4c54f9d10978ffbb99078b"
  version "20100515"

  depends_on "boost" => :build

  def install
    system "make", "all"
    bin.install "cputhrottle"
  end

end
