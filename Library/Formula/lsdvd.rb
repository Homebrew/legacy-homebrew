require 'formula'

class Lsdvd < Formula
  homepage 'http://sourceforge.net/projects/lsdvd'
  url 'http://downloads.sourceforge.net/project/lsdvd/lsdvd/0.16%20-%20I%20hate%20James%20Blunt/lsdvd-0.16.tar.gz'
  sha1 'd5c0d32bfb220807ebdc0bfbb17679e7294791f4'

  depends_on 'libdvdread'
  depends_on 'libdvdcss' => :optional

  def patches
    {:p0 => [
       "https://trac.macports.org/export/89276/trunk/dports/sysutils/lsdvd/files/patch-configure.diff",
       "https://trac.macports.org/export/89276/trunk/dports/sysutils/lsdvd/files/patch-lsdvd_c.diff"
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
