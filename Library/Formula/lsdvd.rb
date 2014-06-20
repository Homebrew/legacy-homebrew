require 'formula'

class Lsdvd < Formula
  homepage 'http://sourceforge.net/projects/lsdvd'
  url 'https://downloads.sourceforge.net/project/lsdvd/lsdvd/0.16%20-%20I%20hate%20James%20Blunt/lsdvd-0.16.tar.gz'
  sha1 'd5c0d32bfb220807ebdc0bfbb17679e7294791f4'

  depends_on 'libdvdread'
  depends_on 'libdvdcss' => :optional

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/sysutils/lsdvd/files/patch-configure.diff"
    sha1 "d2862df4b56cbe9ccf996514a2c30721adb19f0a"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/sysutils/lsdvd/files/patch-lsdvd_c.diff"
    sha1 "1bc07f38486522c7585b89768b20afe8d0b1e7d7"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
