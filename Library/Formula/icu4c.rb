require "formula"

class Icu4c < Formula
  homepage "http://site.icu-project.org/"
  head "http://source.icu-project.org/repos/icu/icu/trunk/", :using => :svn
  url "http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-src.tgz"
  version "54.1"
  sha1 "8c752490bbf31cea26e20246430cee67d48abe34"

  bottle do
    sha1 "1199e740fbc35f09eaa3774ada8c805c885ca170" => :mavericks
    sha1 "72a163ec611ab7ee984d823fca4202d254627372" => :mountain_lion
    sha1 "69037c3eacbf544ab6191e4290c1bc4a6dbdcda0" => :lion
  end

  keg_only "Conflicts; see: https://github.com/Homebrew/homebrew/issues/issue/167"

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
