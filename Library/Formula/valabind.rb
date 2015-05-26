require "formula"

class Valabind < Formula
  homepage "http://radare.org/"
  head "https://github.com/radare/valabind.git"
  url "https://github.com/radare/valabind/archive/0.9.0.tar.gz"
  sha1 "65af558a0116c1d8598992637cfd994cc7e23407"

  bottle do
    cellar :any
    sha1 "960e67a45a8b486e4d38d2d8bbfd16a93658f747" => :yosemite
    sha1 "369e7b1c0a1cc1ab88d7a2fe0700d57a957dd9d3" => :mavericks
    sha1 "4fd99adf2bb6ad5ca350c4ac76bf4ba7b1b0737c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
