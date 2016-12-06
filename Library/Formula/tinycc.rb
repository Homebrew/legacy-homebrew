require 'formula'

class Tinycc < Formula
  # This is a modified version of tcc, which generate MACH-O binaries as opposed
  # to the original tcc which can only generate ELF.
  # It was posted in tcc's mailing list, and the patch is over 78k lines.
  # http://lists.gnu.org/archive/html/tinycc-devel/2011-08/msg00030.html
  url 'https://gd.meizo.com/tcc-0.9.25-osx.tar.gz'
  version '0.9.25'
  homepage 'http://bellard.org/tcc/'
  md5 'acc601e60286c1f4ed60ca14c3ba740d'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
