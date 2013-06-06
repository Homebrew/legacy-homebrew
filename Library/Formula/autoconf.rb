require 'formula'

class Autoconf < Formula
  homepage 'http://www.gnu.org/software/autoconf'
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz'
  sha1 '562471cbcb0dd0fa42a76665acf0dbb68479b78a'

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/autoconf"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Autoconf."
  end

  def install
    # force autoreconf to look for and use our glibtoolize
    inreplace 'bin/autoreconf.in', 'libtoolize', 'glibtoolize'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    cp "#{share}/autoconf/autotest/autotest.m4", 'autotest.m4'
    system "#{bin}/autoconf", 'autotest.m4'
  end
end
