require 'formula'

class Indent <Formula
  url 'http://mirrors.kernel.org/gnu/indent/indent-2.2.10.tar.gz'
  homepage 'http://www.gnu.org/software/indent/'
  md5 'be35ea62705733859fbf8caf816d8959'

  depends_on "gettext"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "touch man/malloc.h"
    system "make"
    system "make install"
  end
end
