require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/52.1/icu4c-52_1-src.tgz'
  version '52.1'
  sha1 '6de440b71668f1a65a9344cdaf7a437291416781'
  head 'http://source.icu-project.org/repos/icu/icu/trunk/', :using => :svn

  bottle do
    sha1 '3205496d69fcf985a92954a170dc29abbbc6ae85' => :mountain_lion
    sha1 '7188afe2066586d3c79480f591f0c373a32422a0' => :lion
    sha1 'cd9b8955fc41b46fa57c6f3697e4689eff02c7c3' => :snow_leopard
  end

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
