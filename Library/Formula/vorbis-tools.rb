class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "http://vorbis.com"
  url "http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
  sha256 "a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc"

  bottle do
    sha256 "86bd3f84faae6355103c59ddd5f04d9e828f2b911a71ab24f1b5669f17d549fa" => :mavericks
    sha256 "4b4e958341edfa08404f9011fd657826619e8187c5529f274d9bc44d1ebb8985" => :mountain_lion
    sha256 "f633e5c0dc5947505a8dfab83dba54538d733287b131de59d364763cb7d213f2" => :lion
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
