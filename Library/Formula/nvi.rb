require 'formula'

class Nvi < Formula
  homepage 'https://sites.google.com/a/bostic.com/keithbostic/vi/'
  url 'http://ftp.de.debian.org/debian/pool/main/n/nvi/nvi_1.81.6.orig.tar.gz'
  sha1 'ce3e0d7d476fb3bdcce9d547e170152290db0347'

  depends_on 'berkeley-db4'

  # Patches per MacPorts
  # The first corrects usage of BDB flags.
  def patches
    {:p0 => [
      "https://trac.macports.org/export/108622/trunk/dports/editors/nvi/files/patch-common__db.h",
      "https://trac.macports.org/export/108622/trunk/dports/editors/nvi/files/patch-dist__port.h.in",
      "https://trac.macports.org/export/108622/trunk/dports/editors/nvi/files/patch-ex_script.c.diff"
    ]}
  end

  def install
    cd 'dist' do
      system "./configure", "--prefix=#{prefix}",
                            "--program-prefix=n",
                            "--disable-dependency-tracking"
      system "make"
      ENV.j1
      system "make install"
    end
  end
end
