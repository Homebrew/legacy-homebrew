require 'formula'

class Srtp < Formula
  homepage 'https://github.com/cisco/libsrtp'
  url 'https://codeload.github.com/cisco/libsrtp/tar.gz/v1.5.0'
  sha1 'fbace084aa58dddc295e15aeab80208f154b4f16'

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
