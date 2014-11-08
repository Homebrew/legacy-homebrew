require "formula"

class SndfileTools < Formula
  homepage "http://www.mega-nerd.com/libsndfile/tools/"
  url "http://www.mega-nerd.com/libsndfile/files/sndfile-tools-1.03.tar.gz"
  sha1 "df7135f5291c1188f0a8c07c82c2d4ec0520a6e3"

  head "https://github.com/erikd/sndfile-tools.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libsndfile"
  depends_on "fftw"
  depends_on JackDependency
  depends_on "libsamplerate" => ["with-fftw", "with-libsndfile"]
  depends_on "cairo"

  option :universal

  def install
    ENV.universal_binary if build.universal?

    if !build.stable?
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "sndfile-generate-chirp", "-h"
    system "sndfile-jackplay", "-h" if !build.stable?
    system "sndfile-spectrogram", "-h"
    system "sndfile-mix-to-mono", "-h"
  end
end
