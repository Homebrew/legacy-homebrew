require 'formula'

class Dc3dd < Formula
  homepage 'http://sourceforge.net/projects/dc3dd/'
  url 'https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.1.0/dc3dd-7.1.614.tar.gz'
  sha1 '808abb6472861a88efd94fd22ffea7021007d769'

  def install
    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}
              --infodir=#{info}]

    # Check for stpncpy is broken, and the replacement fails to compile
    # on Lion and newer; see https://github.com/Homebrew/homebrew/issues/21510
    args << "gl_cv_func_stpncpy=yes" if MacOS.version >= :lion
    system "./configure", *args
    system "make"
    system "make install"
    prefix.install %w[Options_Reference.txt Sample_Commands.txt]
  end
end
