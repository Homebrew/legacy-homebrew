class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "http://vorbis.com"
  url "http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
  sha256 "a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc"

  bottle do
    sha1 "9d71b311da8692a1b58f8cf2d3e84229ea2d645e" => :mavericks
    sha1 "6b81af99edec3ca22a5c5c6a2956ca36d6fe00a4" => :mountain_lion
    sha1 "6ada37aaab0e6a9ab6388910ce80f9ac36fc0b04" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "libao"
  depends_on "flac" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-nls",
      "--prefix=#{prefix}"
    ]

    args << "--without-flac" if build.without? "flac"

    system "./configure", *args
    system "make", "install"
  end
end
