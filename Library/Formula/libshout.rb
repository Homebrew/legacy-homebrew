require 'formula'

class Libshout < Formula
  homepage 'http://www.icecast.org/'
  url 'http://downloads.xiph.org/releases/libshout/libshout-2.3.1.tar.gz'
  sha1 '147c5670939727420d0e2ad6a20468e2c2db1e20'

  bottle do
    cellar :any
    sha1 "c8539d5b6f27a42d5c481d5de7f71370f7d29d8a" => :mavericks
    sha1 "eb9c3d98cd68e15eab1661cb54252c71d4dc667a" => :mountain_lion
    sha1 "c40f3d65386a7de3845ea5751e25c0e377debccc" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'theora'
  depends_on 'speex'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
