require 'formula'

class Rancid < Formula
  homepage 'http://www.shrubbery.net/rancid/'
  url 'ftp://ftp.shrubbery.net/pub/rancid/rancid-3.1.tar.gz'
  sha1 '5e5bdf84634c958ad4cd413c3e31c348340ebd05'

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/rancid", "-t", "cisco", "localhost"
  end
end
