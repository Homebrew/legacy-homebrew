require 'formula'

class Stress < Formula
  homepage 'http://rpmfind.net/linux/RPM/fedora/18/x86_64/s/stress-1.0.4-8.fc18.x86_64.html'
  url 'ftp://ftp.oregonstate.edu/.2/gentoo/distfiles/stress-1.0.4.tar.gz'
  sha1 '7ccb6d76d27ddd54461a21411f2bc8491ba65168'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
