require 'formula'

class Povray < Formula
  url 'http://www.povray.org/ftp/pub/povray/Official/Unix/povray-3.6.1.tar.bz2'
  homepage 'http://www.povray.org/'
  sha1 '1fab3ccbdedafbf77e3a66087709bbdf60bc643d'

  depends_on 'libtiff' => :optional
  depends_on 'jpeg' => :optional

  # TODO give this a build number (2326?)
  fails_with :llvm do
    cause "povray fails with 'terminate called after throwing an instance of int'"
  end if MacOS.version == :leopard

  def patches
    # povray has issues determining libpng version; can't get it to compile
    # against system libpng, but it works with its internal libpng.
    # Look at this again on the next povray version bump!
    {:p0 => "https://trac.macports.org/export/97719/trunk/dports/graphics/povray/files/patch-configure"}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "COMPILED_BY=homebrew",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def test
    ohai "Rendering all test scenes; this may take a while"
    mktemp do
      system "#{share}/povray-3.6/scripts/allscene.sh", "-o", "."
    end
  end
end
