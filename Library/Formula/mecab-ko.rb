require "formula"

class MecabKo < Formula
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.1.tar.gz"
  version "0.996-ko-0.9.1"
  sha1 "3bcd8d1786eee7bb53432e2dd9d5f27a173356d2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
