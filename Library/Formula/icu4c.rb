require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/52.1/icu4c-52_1-src.tgz'
  version '52.1'
  sha1 '6de440b71668f1a65a9344cdaf7a437291416781'
  head 'http://source.icu-project.org/repos/icu/icu/trunk/', :using => :svn

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  option :universal

  def install
    ENV.universal_binary if build.universal?

    args = ["--prefix=#{prefix}", "--disable-samples", "--disable-tests", "--enable-static"]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?
    cd "source" do
      system "./configure", *args
      system "make"
      system "make install"
    end
  end
end
