require 'formula'

class Pianobar < Formula
  url 'https://github.com/PromyLOPh/pianobar/zipball/2011.07.09'
  version '2011.07.09'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 '5a19a10c83c1bf42ee4360e1a9773dfd'

  head 'https://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  skip_clean 'bin'

  fails_with_llvm "Reports of this not compiling on Xcode 4"

  def install
    # Help non-default install paths
    lib_path = HOMEBREW_PREFIX.to_s == "/usr/local" ? "" : " -I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    ENV.append 'CFLAGS', "-std=c99 #{lib_path}"

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    # Install contrib folder too, why not.
    prefix.install Dir['contrib']
  end
end
