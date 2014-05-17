require 'formula'

class Recode < Formula
  homepage 'http://recode.progiciels-bpi.ca/index.html'
  url 'https://github.com/pinard/Recode/archive/v3.7-beta2.tar.gz'
  sha1 'a10c90009ad3e1743632ada2a302c824edc08eaf'
  version '3.7-beta2'

  depends_on "gettext"
  depends_on "libtool" => :build

  def install
    # Yep, missing symbol errors without these
    ENV.append 'LDFLAGS', '-liconv'
    ENV.append 'LDFLAGS', '-lintl'

    cp Dir["#{Formula["libtool"].opt_share}/libtool/config/config.*"], buildpath

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-included-gettext",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make install"
  end
end
