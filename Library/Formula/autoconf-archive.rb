require "formula"

class AutoconfArchive < Formula
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2014.10.15.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2014.10.15.tar.xz"
  sha1 "7efcefd29a67da2a7243ea2b30e353027d70b460"

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make install'
  end
end
