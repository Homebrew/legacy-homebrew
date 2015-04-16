class Snapraid < Formula
  homepage "http://snapraid.sourceforge.net/"
  head "git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid"
  url "https://downloads.sourceforge.net/project/snapraid/snapraid-7.1.tar.gz"
  sha1 "3aa3ee982c21c6e19f31988cc1805dc535404334"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
