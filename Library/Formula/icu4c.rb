require 'formula'

class Icu4c < Formula
  homepage 'http://site.icu-project.org/'
  url 'http://download.icu-project.org/files/icu4c/53.1/icu4c-53_1-src.tgz'
  version '53.1'
  sha1 '7eca017fdd101e676d425caaf28ef862d3655e0f'
  head 'http://source.icu-project.org/repos/icu/icu/trunk/', :using => :svn

  bottle do
    revision 1
    sha1 'c38fd0be5f63a0dd187ee76a9321d543d02d3638' => :mavericks
    sha1 '636b03a9cfd3e686b7c89891eddb74ba34cbf456' => :mountain_lion
    sha1 'f09512efdb8b12edfe080492a5a1c0bafc5a2941' => :lion
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
      system "make", "VERBOSE=1"
      system "make", "VERBOSE=1", "install"
    end
  end
end
