require 'formula'

class Mediatomb < Formula
  homepage 'http://mediatomb.cc'
  url 'https://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz'
  sha1 '86e880584cc9c8aaf3926d56048510d1d06e76b4'

  depends_on 'libexif' => :recommended
  depends_on 'libmagic' => :recommended
  depends_on 'lzlib' => :recommended
  depends_on 'mp4v2' => :recommended
  depends_on 'spidermonkey' => :recommended
  depends_on 'sqlite' => :recommended
  depends_on 'taglib' => :recommended

  depends_on 'ffmpeg' => :optional
  depends_on 'ffmpegthumbnailer' => :optional
  depends_on 'id3lib' => :optional
  depends_on 'lastfmlib' => :optional
  depends_on 'mysql' => :optional

  # This is for libav 0.7 support. See:
  # https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431
  # http://sourceforge.net/tracker/?func=detail&aid=3291062&group_id=129766&atid=715780
  patch do
    url "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"
    sha1 "8f8811d3879f4b8d2e1132fe2016a54b4fdf5b87"
  end

  patch do
    url "http://ftp.heanet.ie/mirrors/fink/finkinfo/10.7/stable/main/finkinfo/net/mediatomb.patch"
    sha1 "d3b626d4071276eda7bc008a61b98b500cd58456"
  end

  patch do
    url "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-misc/mediatomb/files/mediatomb-0.12.1-libav9.patch"
    sha1 "d9e49e57f2cec433acfac5df8040b6fd3b4190a5"
  end

  patch do
    url "http://sourceforge.net/tracker/download.php?group_id=129766&atid=715782&file_id=445437&aid=3532724"
    sha1 "7f4f9ef10fcbb05de95780f43bf4df9bd6563918"
  end

  # Upstream patch: http://sourceforge.net/p/mediatomb/patches/35/
  patch do
    url "https://gist.githubusercontent.com/jacknagel/0971b2626b3a3c86c055/raw/31e568792918b57622dba559658e4161ad87f519/0010_fix_libmp4v2_build.patch"
    sha1 "5b879fc1640e2283941075e555212d4b81dd8e48"
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
