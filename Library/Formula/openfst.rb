require 'formula'

class Openfst < Formula
  homepage 'http://www.openfst.org/'
  url 'http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.3.4.tar.gz'
  sha1 '21972c05896b2154a3fa1bdca5c9a56350194b38'

  def install
    ENV.libstdcxx if ENV.compiler == :clang
    #if MacOS.version > :mountain_lion
    #  ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/c++/4.2.1"
    #  ENV.append 'LIBS', "#{MacOS.sdk_path}/usr/lib/libstdc++.dylib"
    #end
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-far", 
                          "--enable-pdt"
    system "make install"
  end
end
