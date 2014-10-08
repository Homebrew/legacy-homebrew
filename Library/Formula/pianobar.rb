require "formula"

class Pianobar < Formula
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "http://6xq.net/projects/pianobar/pianobar-2014.09.28.tar.bz2"
  sha256 "6bd10218ad5d68c4c761e02c729627d2581b4a6db559190e7e52dc5df177e68f"
  head "https://github.com/PromyLOPh/pianobar.git"

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"
  depends_on "ffmpeg"

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
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end
end
