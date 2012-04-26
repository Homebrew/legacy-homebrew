require 'formula'

class Pianobar < Formula
  homepage 'https://github.com/PromyLOPh/pianobar/'
  url 'https://github.com/PromyLOPh/pianobar/tarball/2012.04.24'
  md5 'bbdb0f5e0bfd811496488e5c3b85a8fd'

  head 'https://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'
  depends_on 'gnutls'

  skip_clean 'bin'

  fails_with :llvm do
    build 2334
    cause "Reports of this not compiling on Xcode 4"
  end

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
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

  # (Temporary?) workaround for pandora protocol change
  # For detail: https://github.com/PromyLOPh/pianobar/issues/236
  def patches
    "https://raw.github.com/gist/2500616/bf2fc7c339791be9dce8ebf0ecca3f6647c9e3f2/gistfile1"
  end
end
