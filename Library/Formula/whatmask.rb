require 'formula'

class Whatmask < Formula
  homepage 'http://www.laffeycomputer.com/whatmask.html'
  url 'http://downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz'
  sha1 '313762672acacd40de8021132b1024a5c96e2ad5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    %x[#{bin}/whatmask /24].eql? <<-EOS

---------------------------------------------
       TCP/IP SUBNET MASK EQUIVALENTS
---------------------------------------------
CIDR = .....................: /24
Netmask = ..................: 255.255.255.0
Netmask (hex) = ............: 0xffffff00
Wildcard Bits = ............: 0.0.0.255
Usable IP Addresses = ......: 254

EOS
  end
end
