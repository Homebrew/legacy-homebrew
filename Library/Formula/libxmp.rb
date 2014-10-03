require "formula"

class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.0/libxmp-4.3.0.tar.gz"
  sha1 "7cc6acef4d3b86b9073851649d1b5f6f4a904e43"

  bottle do
    cellar :any
    sha1 "5d838e452561152cbc569996d0b6c721a447bbc3" => :mavericks
    sha1 "7ae31575dc3f7e052117a4d274ef65556095f485" => :mountain_lion
    sha1 "39a97017b0ee409c2e6fe39a97c2be672393bcff" => :lion
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
