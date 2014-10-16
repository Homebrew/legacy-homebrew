require "formula"

class Icu4c < Formula
  homepage "http://site.icu-project.org/"
  head "http://source.icu-project.org/repos/icu/icu/trunk/", :using => :svn
  url "http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-src.tgz"
  version "54.1"
  sha1 "8c752490bbf31cea26e20246430cee67d48abe34"

  bottle do
    sha1 "984f992aa1e6e35866aa8ed28da06e6d3e6ce29d" => :mavericks
    sha1 "2d6234ded70b57db9f8bc18a956dec3a9666491d" => :mountain_lion
    sha1 "c7de3cc30819af40dbbc185d9cd9dd299ea3dc5a" => :lion
  end

  keg_only :provided_by_osx, "OS X provides libicucore.dylib (but nothing else)."

  option :universal
  option :cxx11

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    args = ["--prefix=#{prefix}", "--disable-samples", "--disable-tests", "--enable-static"]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?
    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end
end
