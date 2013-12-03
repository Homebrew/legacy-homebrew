require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  # Use GitHub tarball as the release tarball doesn't have
  # everything needed for building on OS X
  url 'https://github.com/plt/racket/archive/v5.3.6.tar.gz'
  sha1 '6b0e7a11bb3ae6480b99db346e5b503a97539e6b'

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
