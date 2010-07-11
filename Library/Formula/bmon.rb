require 'formula'

class Bmon <Formula
  url 'http://ftp.debian.org/debian/pool/main/b/bmon/bmon_2.0.1.orig.tar.gz'
  homepage 'http://freshmeat.net/projects/bmon/' # actually: http://people.suug.ch/~tgr/bmon
  md5 'd0da9d05f18c82a621171985d536dec7'

  depends_on 'ncursesw'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-debug", "--disable-dependency-tracking"
    system "make" # two steps to prevent blowing up
    system "make install"
  end
end
