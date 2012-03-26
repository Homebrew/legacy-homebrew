require 'formula'

class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/downloads/BIC-MNI/minc/minc-2.1.12.tar.gz'
  md5 '48ccd7dbc52a9301301f5abc370c3f8c'

  head 'https://github.com/BIC-MNI/minc.git'

  #fails_with_clang "Throws 'non-void function 'miget_real_value_hyperslab' should return a value' error during build.", :build => 318

  depends_on 'netcdf'

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--instal"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
