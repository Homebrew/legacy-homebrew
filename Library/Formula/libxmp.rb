require "formula"

class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.0/libxmp-4.3.0.tar.gz"
  sha1 "7cc6acef4d3b86b9073851649d1b5f6f4a904e43"

  bottle do
    cellar :any
    revision 1
    sha1 "05a81df01e7861ccefd955673bd1a17604bd4100" => :yosemite
    sha1 "772668a1ad68de0596a42ee9c75c37b82f5d027f" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on :autoconf
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
