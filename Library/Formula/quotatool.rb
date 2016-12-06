require 'formula'

class Quotatool < Formula
  homepage 'http://quotatool.ekenberg.se'
  url 'http://quotatool.ekenberg.se/quotatool-1.6.2.tar.gz'
  sha1 '632f8f470530928c57912eb95dfa540c55599c18'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "mkdir -p #{sbin} #{man8}"
    system "make install"
  end

  def test
    system "quotatool"
  end
end
