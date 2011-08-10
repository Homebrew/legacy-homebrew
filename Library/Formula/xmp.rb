require 'formula'

class Xmp < Formula
  url 'http://downloads.sourceforge.net/project/xmp/xmp/3.4.0/xmp-3.4.0.tar.gz'
  homepage 'http://xmp.sourceforge.net'
  md5 '8d18f1340e46278f7006c4d6df385e4b'

  def patches
    # fixes compilation error with GCC 4.2
    # can be removed in the next release
    # http://sourceforge.net/mailarchive/message.php?msg_id=27928353
    "http://downloads.sourceforge.net/project/xmp/xmp/3.4.0/xmp-3.4.0-ununsed-but-set-variable-gcc-warning.patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
