require 'formula'

class Dvdrtools < Formula
  homepage 'http://savannah.nongnu.org/projects/dvdrtools/'
  url 'http://savannah.nongnu.org/download/dvdrtools/dvdrtools-0.2.1.tar.gz'
  sha1 'b8b889f73953c121acd85ce1b4ba988ef7ef6bfc'

  conflicts_with 'cdrtools',
    :because => 'both cdrtools and dvdrtools install binaries by the same name'

  patch :p0 do
    url "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-cdda2wav-cdda2wav.c"
    sha1 "5af074ccbe4d6bdaae9ebeee37e5453eb365aa5a"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-cdrecord-cdrecord.c"
    sha1 "9c588a5cc0bc397d2b64715e5ec8874674c4e9cf"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-scsi-mac-iokit.c"
    sha1 "5a60d186e102fa827698d8b99e6aeb8c15846183"
  end

  def install
    ENV['LIBS'] = '-framework IOKit -framework CoreFoundation'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system 'make install'
  end
end
