class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  url "https://ssl.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz"
  mirror "https://fossies.org/linux/misc/icu4c-56_1-src.tgz"
  version "56.1"
  sha256 "3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816"

  head "https://ssl.icu-project.org/repos/icu/icu/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "a6ca9e033a1b0cc58620b5ab70dc32565a7700cc643773476ed8e1b7e5641d2c" => :el_capitan
    sha256 "b1e4a9fcf06da4c0303d95d10fbc40b5553c22f97d5586d696807ac44a80e55b" => :yosemite
    sha256 "64996840dbc39cb4a02cedc5d6bf2d266c01cab8ad46d956a12daf9b40c65763" => :mavericks
  end

  keg_only :provided_by_osx, "OS X provides libicucore.dylib (but nothing else)."

  option :universal
  option :cxx11

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    args = %W[--prefix=#{prefix} --disable-samples --disable-tests --enable-static]
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
