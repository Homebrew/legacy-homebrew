require 'formula'

class Pianobar < Formula
  url 'https://github.com/PromyLOPh/pianobar/tarball/2011.12.11'
  version '2011.12.11'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 'c8573c133851ff54649d1ab45c7b855c'

  head 'https://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'
  depends_on 'gnutls'

  skip_clean 'bin'

  fails_with_llvm "Reports of this not compiling on Xcode 4", :build => 2334

  def install
    # we discard Homebrew's CFLAGS as Pianobar reportdely doesn't like them
    ENV['CFLAGS'] = "-O2 -DNDEBUG " +
              # fixes a segfault: https://github.com/PromyLOPh/pianobar/issues/138
              "-D_DARWIN_C_SOURCE " +
              # Or it doesn't build at all
              "-std=c99 " +
              # build if we aren't /usr/local'
              "#{ENV["CPPFLAGS"]} #{ENV["LDFLAGS"]}"

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    # Install contrib folder too, why not.
    prefix.install Dir['contrib']
  end
end
