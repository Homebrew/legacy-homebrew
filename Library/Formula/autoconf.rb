require 'formula'

class Autoconf < Formula
  homepage 'http://www.gnu.org/software/autoconf'
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz'
  sha1 '562471cbcb0dd0fa42a76665acf0dbb68479b78a'

  bottle do
    sha1 '2b69898b2827740e5983e25c7f20c0328201b256' => :mavericks
    sha1 'ec30045d8fe4be10858b66d59f029fb19fe63b5e' => :mountain_lion
    sha1 'e7d6d88e762996c2fb96238f7d9e48e6d0feaeba' => :lion
  end

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/autoconf"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Autoconf."
  end

  def install
    ENV['PERL'] = '/usr/bin/perl'

    # force autoreconf to look for and use our glibtoolize
    inreplace 'bin/autoreconf.in', 'libtoolize', 'glibtoolize'
    # also touch the man page so that it isn't rebuilt
    inreplace 'man/autoreconf.1', 'libtoolize', 'glibtoolize'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    cp "#{share}/autoconf/autotest/autotest.m4", 'autotest.m4'
    system "#{bin}/autoconf", 'autotest.m4'
  end
end
