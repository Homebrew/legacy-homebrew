require 'formula'

class Ssdeep < Formula
  homepage 'http://ssdeep.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.10/ssdeep-2.10.tar.gz'
  sha256 '5b893b8059941476352fa1794c2839b2cc13bc2a09e2f2bb6dea4184217beddc'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
