require 'formula'

class Openfst < Formula
  url 'http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.3.4.tar.gz'
  homepage 'http://www.openfst.org/'
  sha1 '21972c05896b2154a3fa1bdca5c9a56350194b38'

  option 'with-far', 'enable finite state transducer archive support needed for OpenGrm'
  option 'with-pdt', 'enable push-down automata support needed for OpenGrm'

  def install
    if MacOS.version > :mountain_lion
      ENV.append 'CXXFLAGS', "-I#{MacOS.sdk_path}/usr/include/c++/4.2.1"
      ENV.append 'LIBS', "#{MacOS.sdk_path}/usr/lib/libstdc++.dylib"
    end
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-far" if build.with? 'far'
    args << "--enable-pdt" if build.with? 'pdt'
    system "./configure", *args
    system "make install"
  end
end
