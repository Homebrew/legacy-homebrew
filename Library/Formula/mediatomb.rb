require 'formula'

class Mediatomb < Formula
  homepage 'http://mediatomb.cc'
  url 'http://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz'
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
  def patches
    [
      "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch",
      "http://mirror.lug.udel.edu/pub/fink/finkinfo/10.7/stable/main/finkinfo/net/mediatomb.patch",
      "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-misc/mediatomb/files/mediatomb-0.12.1-libav9.patch",
      "http://sourceforge.net/tracker/download.php?group_id=129766&atid=715782&file_id=445437&aid=3532724"
    ]
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Edit the config file ~/.mediatomb/config.xml before running mediatomb.
    EOS
  end
end
