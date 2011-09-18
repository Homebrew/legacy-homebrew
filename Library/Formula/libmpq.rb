require 'formula'

class Libmpq < Formula
  # libmpq.org has seen prolonged downtime
  head 'https://github.com/ge0rg/libmpq.git'
  homepage 'https://github.com/ge0rg/libmpq'

  def install
    # on OS X, it's 'glibtoolize'
    inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
