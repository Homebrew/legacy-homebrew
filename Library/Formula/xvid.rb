require 'formula'

class Xvid < Formula
  homepage 'http://www.xvid.org'
  url 'http://fossies.org/unix/privat/xvidcore-1.3.2.tar.gz'
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror 'http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz'
  sha1 '56e065d331545ade04c63c91153b9624b51d6e1b'

  def install
    cd 'build/generic' do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.j1 # Or make fails
      system "make"
      system "make install"
    end
  end
end
