require 'formula'

class Whatmask < Formula
  url 'http://downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz'
  homepage 'http://www.laffeycomputer.com/whatmask.html'
  md5 '26aeff74dbba70262ccd426e681dcf4a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    %x[ #{bin}/whatmask \/24 ].eql?("\n---------------------------------------------\n       TCP/IP SUBNET MASK EQUIVALENTS\n---------------------------------------------\nCIDR = .....................: /24\nNetmask = ..................: 255.255.255.0\nNetmask (hex) = ............: 0xffffff00\nWildcard Bits = ............: 0.0.0.255\nUsable IP Addresses = ......: 254\n\n")
  end

end

