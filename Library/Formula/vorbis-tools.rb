require 'formula'

class VorbisTools < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz'
  sha1 'fc6a820bdb5ad6fcac074721fab5c3f96eaf6562'

  bottle do
    sha1 "9d71b311da8692a1b58f8cf2d3e84229ea2d645e" => :mavericks
    sha1 "6b81af99edec3ca22a5c5c6a2956ca36d6fe00a4" => :mountain_lion
    sha1 "6ada37aaab0e6a9ab6388910ce80f9ac36fc0b04" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'libao'
  depends_on 'flac' => :optional

  def install

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-nls",
      "--prefix=#{prefix}"
    ]

    args << "--without-flac" if build.without? 'flac'

    system "./configure", *args
    system "make install"
  end
end
