require 'formula'

# 2.2.20 does not build on OS X. See:
# https://github.com/BIC-MNI/minc/pull/16
# https://github.com/mxcl/homebrew/issues/22152
class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/BIC-MNI/minc/archive/minc-2-1-13.tar.gz'
  version '2.1.13'
  sha1 '62eeeab62bb5c977e11166d4e43ba384fd029fd1'

  head 'https://github.com/BIC-MNI/minc.git'

  depends_on :automake
  depends_on :libtool

  depends_on 'netcdf'
  depends_on 'hdf5'

  fails_with :clang do
    # TODO This is an easy fix, someone send it upstream!
    build 425
    cause "Throws 'non-void function 'miget_real_value_hyperslab' should return a value'"
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
