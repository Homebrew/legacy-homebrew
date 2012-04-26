require 'formula'

class Mediatomb < Formula
  homepage 'http://mediatomb.cc'
  url 'http://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz'
  md5 'e927dd5dc52d3cfcebd8ca1af6f0d3c2'

  # This is for libav 0.7 support. See:
  # https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431
  # http://sourceforge.net/tracker/?func=detail&aid=3291062&group_id=129766&atid=715780
  def patches
    "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"
  end

  fails_with :clang do
    build 318
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
