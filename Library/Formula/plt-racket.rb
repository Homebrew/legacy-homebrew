require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  # Use GitHub tarball as the release tarball doesn't have
  # everything needed for building on OS X
  url 'https://github.com/plt/racket/tarball/v5.3.3'
  sha1 '2189e72f04d890e12fa9d2776fc74a6f1ecc2bf7'

  depends_on :libtool

  option 'with-docs', "Build with docs"

  def install
    cd 'src' do
      args = [ "--disable-debug", "--disable-dependency-tracking",
              "--enable-lt=glibtool",
              "--prefix=#{prefix}",
              "--enable-macprefix"]

      args << "--disable-docs" unless build.include? 'with-docs'

      if MacOS.prefer_64_bit?
        args += ["--enable-mac64", "--enable-sgc"]
      end

      system "./configure", *args
      system "make"
      ohai "Installing may take a long time (~40 minutes)" unless ARGV.verbose?
      system "make install"

      rm_rf Dir["#{prefix}/*.app", "#{prefix}/lib/{*.dylib,starter,buildinfo}"]
      rm_rf Dir["#{prefix}/bin/*"] - Dir["#{prefix}/bin/{racket,raco}"]
    end
  end
end
