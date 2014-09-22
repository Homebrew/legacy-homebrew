require "formula"

class Ssdeep < Formula
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.11/ssdeep-2.11.tar.gz"
  sha256 "82cc0e06f44127fc5c9c507881951714981da6187cdcfed0158c9167f39effc7"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
