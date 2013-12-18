require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  head 'https://re2.googlecode.com/hg'
  url 'https://re2.googlecode.com/files/re2-20131024.tgz'
  sha1 '90a356fb205c5004cc4f08e45e02994b898b592a'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
