require 'formula'

class Gengetopt < Formula
  url 'ftp://ftp.gnu.org/gnu/gengetopt/gengetopt-2.22.4.tar.gz'
  homepage 'http://www.gnu.org/software/gengetopt/'
  md5 'e69d1b051784eb3a1c9fae36cb8b25ea'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    # Bug in gengetopt's build system; permissions not set on some
    # scripts required for installation
    chmod_R 0755, 'build-aux/'
    system "make install"
  end
end
