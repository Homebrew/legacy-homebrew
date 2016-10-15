require "formula"

class Libfplll < Formula
  homepage "http://perso.ens-lyon.fr/damien.stehle/fplll/"
  url "http://perso.ens-lyon.fr/damien.stehle/fplll/libfplll-4.0.4.tar.gz"
  sha1 "23db9746166a580db6669bf2f99fe0edcc6e32c6"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
