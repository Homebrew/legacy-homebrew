require 'formula'

class Pngtools < Formula
  homepage 'http://www.stillhq.com/pngtools/'
  # Version 0.4 is the current latest, but the upstream has pulled some useful changes from Gentoo into the SVN that make it build nicely with libpng1.5
  url 'http://www.stillhq.com/svn/trunk/pngtools/', :using => :svn, :revision => 3378
  version '0.4'
  # url 'http://www.stillhq.com/pngtools/source/pngtools_0_4.tgz'
  # sha1 'bc8b4953fbdf993f5837e2df510d2341e0ab7d54'
  head 'http://www.stillhq.com/svn/trunk/pngtools/', :using => :svn

  depends_on :libpng
  depends_on 'automake' => :build

  def install
    # pretty standard, except we seem to need to call automake because the configure script in the repo isn't up to date!
    # it would also be an option to patch Makefile.in based on the changes that automake runs on it.  That would let people avoid running automake, but seems conceptually less elegant
    system "automake"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # To pass the test, we need to feed pnginfo a png file.  Steal one from Dock.app
    system 'pnginfo "`find /System/Library/CoreServices/Dock.app/Contents/Resources/*.png | head -1`"'
  end
end
