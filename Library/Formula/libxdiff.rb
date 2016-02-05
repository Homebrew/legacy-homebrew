class Libxdiff < Formula
  desc "Implements diff functions for binary and text files"
  homepage "http://www.xmailserver.org/xdiff-lib.html"
  url "http://www.xmailserver.org/libxdiff-0.23.tar.gz"
  sha256 "e9af96174e83c02b13d452a4827bdf47cb579eafd580953a8cd2c98900309124"

  bottle do
    cellar :any
    revision 1
    sha256 "6269c8d291cea44aceda9bd8e1e93a061e64d76852e47b781ae49aee28f0c31c" => :yosemite
    sha256 "eb1a482e6da44ad722af99334618ddb17da926f4c88a8c85361e04ce0e59bb54" => :mavericks
    sha256 "04bc25b91630b8d7fb791529e9797d287db42f500af29db45314580a4b2591e5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
