class Mediatomb < Formula
  desc "Open source (GPL) UPnP MediaServer"
  homepage "http://mediatomb.cc"
  url "https://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz"
  sha256 "31163c34a7b9d1c9735181737cb31306f29f1f2a0335fb4f53ecccf8f62f11cd"
  bottle do
    sha1 "716145891055b842417844efb1f786344ba79f56" => :mavericks
    sha1 "d5fd8a1389771a2bf4677dc5f008b0c4249344aa" => :mountain_lion
    sha1 "ae3e70647489adec58c1433652d05bad3844f16a" => :lion
  end

  revision 1

  depends_on "libexif" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "lzlib" => :recommended
  depends_on "mp4v2" => :recommended
  depends_on "spidermonkey" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "taglib" => :recommended

  depends_on "ffmpeg" => :optional
  depends_on "ffmpegthumbnailer" => :optional
  depends_on "id3lib" => :optional
  depends_on "lastfmlib" => :optional
  depends_on "mysql" => :optional

  # This is for libav 0.7 support. See:
  # https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431
  # http://sourceforge.net/tracker/?func=detail&aid=3291062&group_id=129766&atid=715780
  patch do
    url "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"
    sha256 "c6523e8bf5e2da89b7475d6777ef9bffe7d089752ef2f7b27b5e39a4130fb0ff"
  end

  patch do
    url "http://ftp.heanet.ie/mirrors/fink/finkinfo/10.7/stable/main/finkinfo/net/mediatomb.patch"
    sha256 "7e8ef3e1bec9a045549b468a3441f9d3d7bb42a7e77564a5fedea2d6024303ea"
  end

  patch do
    url "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-misc/mediatomb/files/mediatomb-0.12.1-libav9.patch"
    sha256 "ae07427380e22f7340af28ea8d8d4bd01ec07f1c09bd0e0e50f310b2b4e507e2"
  end

  patch do
    url "http://sourceforge.net/p/mediatomb/patches/_discuss/thread/57c47fb9/8ad8/attachment/mediatomb-urifix.patch"
    sha256 "537373654c1d7fa24e14f2e5a9c78228589411509d46fbd53bb38b87d5ee34fb"
  end

  # Upstream patch: http://sourceforge.net/p/mediatomb/patches/35/
  patch do
    url "https://gist.githubusercontent.com/jacknagel/0971b2626b3a3c86c055/raw/31e568792918b57622dba559658e4161ad87f519/0010_fix_libmp4v2_build.patch"
    sha256 "8823da463d22c74b0a87a0054e1594e2fb8d418eff93b86e346e5506bb5a7323"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.without? "mp4v2"
      args << "--disable-libmp4v2"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Edit the config file ~/.mediatomb/config.xml before running mediatomb.
    EOS
  end
end
