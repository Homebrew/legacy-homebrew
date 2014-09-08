require 'formula'

class Mktorrent < Formula
  homepage 'http://mktorrent.sourceforge.net/'
  url 'https://downloads.sourceforge.net/mktorrent/mktorrent-1.0.tar.gz'
  sha1 'f9b1bbf9d19911b6c8994dbec6208530c7d929ad'

  def install
    system "make USE_PTHREADS=1 USE_OPENSSL=1 USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end
end
