require 'formula'

class Cifer < Formula
  homepage 'http://code.google.com/p/cifer/'
  url 'http://cifer.googlecode.com/files/cifer-1.2.0.tar.gz'
  md5 '6fba4f27b09722ea07524e940c1e923f'

  def install
      system "make", "prefix=#{prefix}",
                     "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
  end
end
