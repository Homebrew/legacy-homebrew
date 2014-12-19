require 'formula'

class Srtp < Formula
  homepage 'https://github.com/cisco/libsrtp'
  url 'https://codeload.github.com/cisco/libsrtp/tar.gz/v1.5.0'
  sha1 'fbace084aa58dddc295e15aeab80208f154b4f16'

  bottle do
    cellar :any
    sha1 "d2cc4fa21913d1055557ac4546b7be1bf70059bf" => :yosemite
    sha1 "7e8b5b4fcd340a57e181179e25aef3554e663993" => :mavericks
    sha1 "079bb268a4ccd761d073d3b4f0eed0d2411bdcaa" => :mountain_lion
  end

  # Add support for building shared libs
  patch do
    # Submitted upstream at https://github.com/cisco/libsrtp/pull/86
    url "http://arunraghavan.net/downloads/brew/srtp-shared-library.patch"
    sha1 "f44ff924a9e14826add202168f61843c1d88ddd4"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make shared_library"
    system "make install" # Can't go in parallel of building the dylib
  end
end
