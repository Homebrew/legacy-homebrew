require 'formula'

class Minc < Formula
  url 'https://github.com/downloads/andrewjanke/minc/minc-2.1.10.tar.gz'
  homepage 'http://en.wikibooks.org/wiki/MINC'
  md5 '64032918928393ee6e1da7e8af3433d8'

  head 'https://github.com/andrewjanke/minc.git'

  #fails_with_clang "Throws 'non-void function 'miget_real_value_hyperslab' should return a value' error during build.", :build => 318

  depends_on 'netcdf'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
