require 'formula'

class Dpkg < Formula
  url        'http://ykf.ca.distfiles.macports.org/MacPorts/mpdistfiles/dpkg/dpkg_1.14.29.tar.gz'
  homepage   'http://packages.debian.org/search?keywords=dpkg'
  md5        '4326172a959b5b6484b4bc126e9f628d'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-sgml-doc",
                          "--with-admindir=#{var}/db/dpkg",
                          "--mandir=#{man}",
                          "--with-zlib",
                          "--with-bz2",
                          "--disable-linker-optimisations"
    system "make"
    system "make install"
  end

  def patches
    # the following gist contains all the necessary patches found here:
    # https://trac.macports.org/browser/trunk/dports/sysutils/dpkg/files
    "https://raw.github.com/gist/1313986/195ad3325f75a2952d23ba591d2ed6acce834a4c/dpkg-patch"
  end

  def test
    system "test -f #{HOMEBREW_PREFIX}/bin/dpkg"
  end
end
