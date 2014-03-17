require 'formula'

class Snapraid < Formula
  homepage 'http://snapraid.sourceforge.net/'
  head 'git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid'
  url 'https://downloads.sourceforge.net/project/snapraid/snapraid-5.3.tar.gz'
  sha1 'f93ace64dc8fd0cf134914a3e11c8d33538d0e77'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
