class Libxdiff < Formula
  desc "Implements diff functions for binary and text files"
  homepage "http://www.xmailserver.org/xdiff-lib.html"
  url "http://www.xmailserver.org/libxdiff-0.23.tar.gz"
  sha256 "e9af96174e83c02b13d452a4827bdf47cb579eafd580953a8cd2c98900309124"

  bottle do
    cellar :any
    revision 1
    sha1 "ced65da17256956abfaca7e8ae0b993959e992b7" => :yosemite
    sha1 "ce2f24d9b189f996b8a60c61f72dd540120ff9f0" => :mavericks
    sha1 "d657af562a1d224182093b29620da4e37db32a83" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
