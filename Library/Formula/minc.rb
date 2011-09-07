require 'formula'

class Minc < Formula
  url 'http://packages.bic.mni.mcgill.ca/tgz/minc-2.1.00.tar.gz'
  homepage 'http://www.nmr.mgh.harvard.edu/~rhoge/minc/'
  md5 '1ef2402abc8f49d870d9f610eb5ad4c8'

  depends_on 'netcdf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
