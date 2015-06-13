class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  head "https://github.com/radare/valabind.git"
  url "https://github.com/radare/valabind/archive/0.9.2.tar.gz"
  sha256 "84cc2be21acb671e737dab50945b3717f1c68917faf23af443d3911774f5e578"

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
