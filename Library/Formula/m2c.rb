class M2c < Formula
  desc "Modula-2 to C compiler"
  homepage "https://savannah.nongnu.org/projects/m2c/"
  url "http://download.savannah.gnu.org/releases/m2c/0.7/m2c-0.7.tar.gz"
  sha256 "b725ed617f376e1a321e059bf1985098e950965d5edab161c6b24526f10a59bc"

  def install
    system "./configure", "+cc=gcc"

    # Makefile is buggy!
    inreplace "Makefile", "install: all uninstall", "install: all"
    inreplace "Makefile", "mkdir", "mkdir -p"
    mkdir_p prefix/"include"

    system "make", "install", "prefix=#{prefix}"
  end
end
