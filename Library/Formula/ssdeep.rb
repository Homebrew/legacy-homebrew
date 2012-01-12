require 'formula'

class Ssdeep < Formula
  url 'http://downloads.sourceforge.net/project/ssdeep/ssdeep-2.7/ssdeep-2.7.tar.gz'
  homepage 'http://ssdeep.sourceforge.net/'
  sha256 'b76a60a8f96789895703316ed3b36d1f0c1f35be892d875b69b0a1f814472a36'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
