require 'formula'

class Dvdrtools < Formula
  homepage 'http://savannah.nongnu.org/projects/dvdrtools/'
  url 'http://savannah.nongnu.org/download/dvdrtools/dvdrtools-0.2.1.tar.gz'
  sha1 'b8b889f73953c121acd85ce1b4ba988ef7ef6bfc'

  conflicts_with 'cdrtools',
    :because => 'both cdrtools and dvdrtools install binaries by the same name'

  def patches
  { :p0 => [
      "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-cdda2wav-cdda2wav.c",
      "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-cdrecord-cdrecord.c",
      "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-scsi-mac-iokit.c"
    ]
  }
  end

  def install
    ENV['LIBS'] = '-lIOKit -framework CoreFoundation'

    system "./configure", '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system 'make install'
  end
end
