require 'formula'

class OpengrmNgram < Formula
  homepage 'http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary'
  url 'http://openfst.cs.nyu.edu/twiki/pub/GRM/NGramDownload/opengrm-ngram-1.1.0.tar.gz'
  sha1 'a2ceeaf6ac129b66d2682d76a20388cf1d4b8c31'

  depends_on 'openfst'

  def install
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system 'make install'
  end
end
