require "formula"

class MecabKo < Formula
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.1.tar.gz"
  version "0.996-ko-0.9.1"
  sha1 "68dad4486d7b74fa5fe7aef0b440e00f17a9e59c"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
