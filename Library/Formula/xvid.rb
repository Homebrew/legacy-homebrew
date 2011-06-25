require 'formula'

class Xvid < Formula
  url 'http://downloads.xvid.org/downloads/xvidcore-1.2.2.tar.gz'
  homepage 'http://www.xvid.org'
  md5 '2ce9b1d280d703b5bc8e702c79e660b5'

  def install
    cd 'build/generic' do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.j1 # Doesn't compile on parallel build
      system "make"
      system "make install" # Need to call these separately
    end
  end
end
