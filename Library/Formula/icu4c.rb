class Icu4c < Formula
  homepage "http://site.icu-project.org/"
  head "https://ssl.icu-project.org/repos/icu/icu/trunk/", :using => :svn
  url "https://ssl.icu-project.org/files/icu4c/55.1/icu4c-55_1-src.tgz"
  version "55.1"
  sha256 "e16b22cbefdd354bec114541f7849a12f8fc2015320ca5282ee4fd787571457b"

  bottle do
    revision 1
    sha1 "244dbb217c95a79f87a35df70aca493a05c9ff39" => :yosemite
    sha1 "a963404c60a1de000c3e9d7478f6318e8f3c9291" => :mavericks
    sha1 "fb48ee8a8fa5aa9537d4e594178bc7e62689156a" => :mountain_lion
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
