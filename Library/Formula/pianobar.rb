require "formula"

class Pianobar < Formula
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://github.com/PromyLOPh/pianobar/archive/2013.09.15.tar.gz"
  sha256 "4b18582eb794def5bf4e7d5de211d1f6c79295edac344928e09072aa9386796c"
  revision 2

  head do
    url "https://github.com/PromyLOPh/pianobar.git"
    depends_on "ffmpeg"
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"

  fails_with :llvm do
    build 2334
    cause "Reports of this not compiling on Xcode 4"
  end

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV['CFLAGS'] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"

    if build.head?
      inreplace "Makefile", "#LIBAV:=ffmpeg2.2", "LIBAV:=ffmpeg2.2"
    end
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end
end
