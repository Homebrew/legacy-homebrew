require "formula"

class Snapraid < Formula
  homepage "http://snapraid.sourceforge.net/"
  head "git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid"
  url "https://downloads.sourceforge.net/project/snapraid/snapraid-6.3.tar.gz"
  sha1 "0a2760913ee16facb9bccf729a980260207e339f"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
