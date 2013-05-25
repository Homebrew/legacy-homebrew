require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  # Use GitHub tarball as the release tarball doesn't have
  # everything needed for building on OS X
  url 'https://github.com/plt/racket/archive/v5.3.4.tar.gz'
  sha1 'a004f838744009c729dc34744846e09022c0f0d7'

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
