require 'formula'

class Bmon <Formula
  url 'http://mirrors.kernel.org/debian/pool/main/b/bmon/bmon_2.0.1.orig.tar.gz'
  homepage 'http://people.suug.ch/~tgr/bmon'
  md5 'd0da9d05f18c82a621171985d536dec7'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make" # two steps to prevent blowing up
    system "make install"
  end
end
