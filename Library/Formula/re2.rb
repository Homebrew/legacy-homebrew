require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  head 'https://re2.googlecode.com/hg'
  url 'https://re2.googlecode.com/files/re2-20130802.tgz'
  sha1 'c2cf57ecd63b754da3021212198c517540276572'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
