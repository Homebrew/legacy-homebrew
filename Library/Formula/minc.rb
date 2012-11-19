require 'formula'

class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/BIC-MNI/minc/tarball/release-2.2.00'
  sha1 '558300240a67b9f849a98622d0e8ec3aad76c6d1'

  head 'https://github.com/BIC-MNI/minc.git'

  depends_on 'netcdf'
  depends_on 'hdf5'

  depends_on :automake
  depends_on :libtool

  fails_with :clang do
    # TODO This is an easy fix, someone send it upstream!
    build 421
    cause "Throws 'non-void function 'miget_real_value_hyperslab' should return a value'"
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
