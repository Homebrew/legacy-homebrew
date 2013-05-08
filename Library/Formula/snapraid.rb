require 'formula'

class Snapraid < Formula
  homepage 'http://snapraid.sourceforge.net/'
  head 'git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid'
  url 'http://downloads.sourceforge.net/project/snapraid/snapraid-4.4.tar.gz'
  sha1 '28c73b431c4fca78194bbfa484bbf0f5f20db17c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
