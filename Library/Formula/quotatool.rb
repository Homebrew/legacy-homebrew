require 'formula'

class Quotatool < Formula
  homepage 'http://quotatool.ekenberg.se'
  url 'http://quotatool.ekenberg.se/quotatool-1.6.2.tar.gz'
  sha1 '632f8f470530928c57912eb95dfa540c55599c18'

  def install
    system "./configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make install"
  end
end
