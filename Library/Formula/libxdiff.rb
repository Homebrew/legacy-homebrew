require 'formula'

class Libxdiff < Formula
  homepage 'http://www.xmailserver.org/xdiff-lib.html'
  url 'http://www.xmailserver.org/libxdiff-0.23.tar.gz'
  sha1 'f92eff48eeb49d5145ddafcb72dcfb18f5d07303'

  bottle do
    cellar :any
    sha1 "c1cce0763a3a260be20748260a7cac0912794120" => :mavericks
    sha1 "6c96659fa393e51c25a404dcf3b56b4bb9cc39f0" => :mountain_lion
    sha1 "b2968cb4164b342b89ada07302e7d9ddc5d97c10" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
