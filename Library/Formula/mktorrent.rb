require 'formula'

class Mktorrent < Formula
  url      'http://downloads.sourceforge.net/mktorrent/mktorrent-1.0.tar.gz'
  homepage 'http://mktorrent.sourceforge.net/'
  md5      '0da00209da96a0dc39efbb6eb5b4d8ff'

  def install
    system "make USE_PTHREADS=1 USE_OPENSSL=1 USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end
end
