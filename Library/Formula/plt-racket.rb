require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  # Use GitHub tarball as the release tarball doesn't have
  # everything needed for building on OS X
  url 'https://github.com/plt/racket/tarball/v5.2'
  sha1 'bb2c6b6504796a88dada10b510f040b5bbec7b2e'

  def install
    cd 'src' do
      args = ["--disable-debug", "--disable-dependency-tracking",
              "--enable-xonx",
              "--enable-shared",
              "--prefix=#{prefix}" ]

      if MacOS.prefer_64_bit?
        args += ["--enable-mac64", "--enable-sgc", "--disable-gracket"]
      end

      system "./configure", *args
      system "make"
      ohai "Installing may take a long time (~40 minutes)" unless ARGV.verbose?
      system "make install"
    end
  end
end
