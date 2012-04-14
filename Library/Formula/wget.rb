require 'formula'

class Wget < Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftpmirror.gnu.org/wget/wget-1.13.4.tar.bz2'
  md5 '12115c3750a4d92f9c6ac62bac372e85'

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--with-ssl=openssl"]

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/wget --version"
  end
end
