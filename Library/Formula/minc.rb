require 'formula'

class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/BIC-MNI/minc/archive/release-2.2.00.tar.gz'
  sha1 'f66f44ece374940bd006f321a7206f16165f74e0'

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
