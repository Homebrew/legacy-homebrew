require 'formula'

class Openmotif < Formula
  url 'http://www.openmotif.org/files/public_downloads/openmotif/2.3/2.3.3/openmotif-2.3.3.tar.gz'
  homepage 'http://www.openmotif.org'
  md5 'fd27cd3369d6c7d5ef79eccba524f7be'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
    "--prefix=#{prefix}", "--enable-xft", "--enable-jpeg", "--enable-png"
    system "make install"
  end

  def patches
    # MacPorts patches
    { :p0 => ['https://trac.macports.org/export/83688/trunk/dports/x11/openmotif/files/patch-uintptr_t-cast.diff',
              'https://trac.macports.org/export/83688/trunk/dports/x11/openmotif/files/patch-lib-Mrm-Makefile.in.diff',
              'https://trac.macports.org/raw-attachment/ticket/30898/patch-demos-programs-periodic-Makefile.in.diff',
              'https://trac.macports.org/raw-attachment/ticket/30898/patch-clients-uil-UilDefI.h.diff']
    }
  end
end
