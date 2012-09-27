require 'formula'

class A2ps < Formula
  homepage 'http://www.gnu.org/software/a2ps/'
  url 'http://ftpmirror.gnu.org/a2ps/a2ps-4.14.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz'
  sha1 '365abbbe4b7128bf70dad16d06e23c5701874852'

  # Software was last updated in 2007, so take MacPorts patches to get
  # it working on 10.6. See:
  # https://svn.macports.org/ticket/20867
  # http://trac.macports.org/ticket/18255
  def patches
    { :p0 => [
      "https://trac.macports.org/export/56498/trunk/dports/print/a2ps/files/patch-contrib_sample_Makefile.in",
      "https://trac.macports.org/export/56498/trunk/dports/print/a2ps/files/patch-lib__xstrrpl.c"
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
