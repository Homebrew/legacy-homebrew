require 'formula'

class Pianobar < Formula
  homepage 'https://github.com/PromyLOPh/pianobar/'
  url 'https://github.com/PromyLOPh/pianobar/tarball/2012.12.01'
  sha256 'bd460ef583d7c2799090ec2abc298bd0c8a7126110dac754f2c242ce95001955'

  head 'https://github.com/PromyLOPh/pianobar.git'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'json-c'

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
                    "#{ENV["CPPFLAGS"]} #{ENV["LDFLAGS"]}"

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    # Install contrib folder too, why not.
    prefix.install 'contrib'
  end
end
