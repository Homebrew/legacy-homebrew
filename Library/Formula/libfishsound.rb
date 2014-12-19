require 'formula'

class Libfishsound < Formula
  homepage 'http://xiph.org/fishsound/'
  url 'http://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz'
  sha1 '5263dfaa12dce71e30c5d80f871d92869c6b5ce2'

  bottle do
    cellar :any
    revision 1
    sha1 "d298837ad460c86599b65b8bdf4ca62a24ac8549" => :yosemite
    sha1 "857f580172e6c109e962179db28085190c7dead1" => :mavericks
    sha1 "1099a2dee3da3ef7748b0e752394e2a4de26d6af" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libvorbis'
  depends_on 'speex' => :optional
  depends_on 'flac' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
