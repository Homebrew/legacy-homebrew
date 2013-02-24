require 'formula'

class Recode < Formula
  homepage 'http://recode.progiciels-bpi.ca/index.html'
  url 'https://github.com/pinard/Recode/archive/v3.7-beta2.tar.gz'
  sha1 'a10c90009ad3e1743632ada2a302c824edc08eaf'
  version '3.7-beta2'

  depends_on "gettext"
  depends_on :libtool

  def copy_libtool_files!
<<<<<<< HEAD
<<<<<<< HEAD
    if MacOS.xcode_version >= "4.3"
=======
    if MacOS::Xcode.version >= "4.3"
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
    if not MacOS::Xcode.provides_autotools?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
      s = Formula.factory('libtool').share
      d = "#{s}/libtool/config"
      cp ["#{d}/config.guess", "#{d}/config.sub"], "."
    elsif MacOS.version == :leopard
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS::Xcode.prefix}/usr/share/libtool/config/config.*"], "."
    end
  end

  def install
    # Yep, missing symbol errors without these
    ENV.append 'LDFLAGS', '-liconv'
    ENV.append 'LDFLAGS', '-lintl'

    copy_libtool_files!

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-included-gettext",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make install"
  end
end
