require 'formula'

class Libdca < Formula
  homepage 'http://www.videolan.org/developers/libdca.html'
  url 'http://download.videolan.org/pub/videolan/libdca/0.0.5/libdca-0.0.5.tar.bz2'
  sha1 '3fa5188eaaa2fc83fb9c4196f6695a23cb17f3bc'

  def install
    # Fixes "duplicate symbol ___sputc" error when building with clang
    # https://github.com/Homebrew/homebrew/issues/31456
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
