class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "https://github.com/radare/valabind/archive/0.9.2.tar.gz"
  sha256 "84cc2be21acb671e737dab50945b3717f1c68917faf23af443d3911774f5e578"
  revision 1

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "ff86a94b9f31232eb5cb00285765d9b3df37a588cf01798c8c65c163f2d7416c" => :yosemite
    sha256 "5d726be71c0fbd7cc9fbfcdf308f7f3734514606d6a7df5afbfead9642e085fe" => :mavericks
    sha256 "fd736eaa0cc6f6823b48633cfd6be15dc2f26de0dba9b895fbe6ea50907e292c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
