require "formula"

class Snapraid < Formula
  homepage "http://snapraid.sourceforge.net/"
  head "git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid"
  url "https://downloads.sourceforge.net/project/snapraid/snapraid-6.2.tar.gz"
  sha1 "2b41ebf2ec909dfa6259cc3842201b0199e99d14"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
