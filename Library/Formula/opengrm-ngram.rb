require 'formula'

class OpengrmNgram < Formula
  url 'http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.1.0.tar.gz'
  homepage 'http://openfst.cs.nyu.edu/twiki/bin/view/GRM/NGramLibrary'
  sha1 'a2ceeaf6ac129b66d2682d76a20388cf1d4b8c31'

  depends_on 'openfst'

  def install
    if MacOS.version > :mountain_lion
      ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/c++/4.2.1"
      ENV.append 'LIBS', "#{MacOS.sdk_path}/usr/lib/libstdc++.dylib"
    end
    system "./configure", "--disable-dependency-tracking", 
                          "--prefix=#{prefix}"
    system "make install"
  end
end
