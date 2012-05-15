require 'formula'

class Minc < Formula
  homepage 'http://en.wikibooks.org/wiki/MINC'
  url 'https://github.com/downloads/BIC-MNI/minc/minc-2.1.12.tar.gz'
  md5 '48ccd7dbc52a9301301f5abc370c3f8c'

  head 'https://github.com/BIC-MNI/minc.git'

  depends_on 'netcdf'

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
