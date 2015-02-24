class Snapraid < Formula
  homepage "http://snapraid.sourceforge.net/"
  head "git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid"
  url "https://downloads.sourceforge.net/project/snapraid/snapraid-7.0.tar.gz"
  sha1 "aec231ec0ad006cfc2f73cff01ed0fd3254dc111"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
