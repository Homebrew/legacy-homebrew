require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  # Use GitHub; tarball doesn't have everything needed for building on OS X
  url 'https://github.com/plt/racket.git', :tag => 'v5.2'
  version '5.2'

  # Don't strip symbols; need them for dynamic linking.
  skip_clean 'bin'

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
      ohai   "Installing might take a long time (~40 minutes)"
      system "make install"
    end
  end
end
