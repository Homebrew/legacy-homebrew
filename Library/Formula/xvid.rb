require 'formula'

class Xvid < Formula
  url 'http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz'
  homepage 'http://www.xvid.org'
  md5 '87c8cf7b69ebed93c2d82ea5709d098a'

  def install
    cd 'build/generic' do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      system "make"
      system "make install" # Need to call these separately
    end
  end
end
