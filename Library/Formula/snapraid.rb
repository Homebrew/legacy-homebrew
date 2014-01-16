require 'formula'

class Snapraid < Formula
  homepage 'http://snapraid.sourceforge.net/'
  head 'git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid'
  url 'http://downloads.sourceforge.net/project/snapraid/snapraid-5.2.tar.gz'
  sha1 'b7abe28323eea6fd39152c34e0d26cf8530663db'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
