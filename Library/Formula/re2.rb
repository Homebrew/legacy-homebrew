require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  head 'https://re2.googlecode.com/hg'
  url 'https://re2.googlecode.com/files/re2-20140111.tgz'
  sha1 'd51b3c2e870291070a1bcad8e5b471ae83e1f8df'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
