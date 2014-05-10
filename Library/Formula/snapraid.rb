require 'formula'

class Snapraid < Formula
  homepage 'http://snapraid.sourceforge.net/'
  head 'git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid'
  url 'https://downloads.sourceforge.net/project/snapraid/snapraid-6.1.tar.gz'
  sha1 '64469900098b297a90d4ccc3e41cd9f447ba76ce'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
