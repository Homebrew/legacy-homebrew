class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  head "https://ssl.icu-project.org/repos/icu/icu/trunk/", :using => :svn
  url "https://ssl.icu-project.org/files/icu4c/55.1/icu4c-55_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-55_1-src.tgz"
  version "55.1"
  sha256 "e16b22cbefdd354bec114541f7849a12f8fc2015320ca5282ee4fd787571457b"

  bottle do
    sha256 "a27e2b3645992acec22c95cb6ff4c4893139d3710c1a0be6d54c9f22593fc148" => :yosemite
    sha256 "c68728ae3a0401fb32ddb3a85eb5ddf8c367268090421d66db2631d49f7b1ce1" => :mavericks
    sha256 "be4ecad0c4f0542df384dd48c8c57380f6d843958c5d1eddb068e52f910e2dd9" => :mountain_lion
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

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
