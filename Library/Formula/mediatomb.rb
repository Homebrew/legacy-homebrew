require 'formula'

class Mediatomb < Formula
  homepage 'http://mediatomb.cc'
  url 'http://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz'
  sha1 '86e880584cc9c8aaf3926d56048510d1d06e76b4'

  depends_on 'spidermonkey'
  depends_on 'libmagic'
  depends_on 'libexif'
  depends_on 'taglib'
  depends_on 'ffmpeg'
  depends_on 'ffmpegthumbnailer'
  depends_on 'lastfmlib'

  # This is for libav 0.7 support. See:
  # https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431
  # http://sourceforge.net/tracker/?func=detail&aid=3291062&group_id=129766&atid=715780
  # Patches copied from macports to help with build.
  # Skipped Patch: "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"

  def patches
    { :p0 => [ "https://trac.macports.org/export/103394/trunk/dports/net/mediatomb/files/patch-configure.ac.diff", "https://trac.macports.org/export/103394/trunk/dports/net/mediatomb/files/patch-src-metadata-ffmpeg_handler.cc.diff" ] }
  end

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      In file included from ../src/content_manager.cc:45:
      In file included from ../src/content_manager.h:36:
      In file included from ../src/storage.h:40:
      In file included from ../src/hash.h:47:
      ../src/hash/dbr_hash.h:127:15: error: use of undeclared identifier 'search'
              if (! search(key, &slot))
    EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
