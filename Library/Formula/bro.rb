require 'formula'

class Bro < Formula
  url 'www.bro-ids.org/downloads/release/bro-2.0.tar.gz'
  homepage 'http://www.bro-ids.org'
  md5 '2ea82a7b4cabf3ff70e26085494e527f'

  depends_on 'swig'
  depends_on 'libmagic'
  depends_on 'geoip'
  depends_on 'cmake' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "bro"
  end
end
