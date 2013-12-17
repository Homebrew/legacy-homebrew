require 'formula'

class Snapraid < Formula
  homepage 'http://snapraid.sourceforge.net/'
  head 'git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid'
  url 'http://downloads.sourceforge.net/project/snapraid/snapraid-5.1.tar.gz'
  sha1 'c36b91fbe56db4a45b6881f17ad8d39bea0b7fb6'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
