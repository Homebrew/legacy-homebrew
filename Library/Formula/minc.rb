require 'formula'

class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/downloads/BIC-MNI/minc/minc-2.1.12.tar.gz'
  sha1 'fb44a74f16de293bec5e587584f2c43994729acc'

  head 'https://github.com/BIC-MNI/minc.git'

  depends_on 'netcdf'

  depends_on :automake
  depends_on :libtool

  fails_with :clang do
    # TODO This is an easy fix, someone send it upstream!
    build 318
    cause "Throws 'non-void function 'miget_real_value_hyperslab' should return a value'"
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
