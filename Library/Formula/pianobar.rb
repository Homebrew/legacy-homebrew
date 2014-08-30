require "formula"

class Pianobar < Formula
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://github.com/PromyLOPh/pianobar/archive/2014.06.08.tar.gz"
  sha256 "55f0105b8bf20af0a74f3ef2f928e81d9fdccc50fe86548f7db7992f523c3529"
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
