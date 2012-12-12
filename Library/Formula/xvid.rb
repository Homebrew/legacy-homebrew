require 'formula'

class Xvid < Formula
  url 'http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz'
  homepage 'http://www.xvid.org'
  sha1 '56e065d331545ade04c63c91153b9624b51d6e1b'

  def install
    cd 'build/generic' do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      system "make"
      ENV.j1 # Or install sometimes fails
      system "make install"
    end
  end
end
