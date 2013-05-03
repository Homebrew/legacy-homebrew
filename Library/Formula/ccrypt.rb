require 'formula'

class Ccrypt < Formula
  homepage 'http://ccrypt.sourceforge.net/'
  url 'http://ccrypt.sourceforge.net/download/ccrypt-1.9.tar.gz'
  sha1 '5ad1889c71be905c3004c80dc011948c9c35c814'

  def install
    # Tests fail with clang (build 318) at higher optimization
    ENV.no_optimization if ENV.compiler == :clang

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
    system "make check"
  end
end
