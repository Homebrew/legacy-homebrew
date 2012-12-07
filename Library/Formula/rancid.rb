require 'formula'

class Rancid < Formula
  homepage 'http://www.shrubbery.net/rancid/'
  url 'ftp://ftp.shrubbery.net/pub/rancid/rancid-2.3.8.tar.gz'
  version '2.3.8'
  sha1 '7469d7f9e39e9f86f977f1f0963300e5d183088f'

  depends_on "expect"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def test
    system "rancid localhost"
  end
end
