require 'formula'

class Ck < Formula
  url 'http://concurrencykit.org/releases/ck-0.0.3.tar.gz'
  homepage 'http://concurrencykit.org'
  md5 '3363a91c5941b33628cc196d583bd740'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
