require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.0.1/libxmp-4.0.1.tar.gz'
  sha1 '2deeb3df362f01dcd39a874c83010c02bf4e8177'
  head 'git://xmp.git.sourceforge.net/gitroot/xmp/xmp'

  depends_on :autoconf if build.head?

  # Fixes channel volume setting
  # Merged upstream, will be in 4.0.2
  def patches
    "http://sourceforge.net/mailarchive/attachment.php?list_name=xmp-devel&message_id=CAGfWt5eaw-5ofKGpM6SO%3D%2BwB0cyVZNi4Y1NFBRnOAXyFqu56yg%40mail.gmail.com&counter=1"
  end unless build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
