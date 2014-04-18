require "formula"

class MecabKo < Formula
  homepage "https://bitbucket.org/bibreen/mecab-ko"
  url "https://bitbucket.org/bibreen/mecab-ko/downloads/mecab-0.996-ko-0.9.0.tar.gz"
  version "0.996-ko-0.9.0"
  sha1 "cd70543d2b60d93398d9f26a3c912dde73c83382"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
