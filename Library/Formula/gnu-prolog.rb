require 'formula'

class GnuProlog < Formula
  homepage 'http://www.gprolog.org/'
  url 'http://www.gprolog.org/gprolog-1.4.1.tar.gz'
  sha1 'f25e11dbef2467c8ea1bb16cfd20623fd2f4fad4'

  fails_with :clang do
    build 318
    cause "Fatal Error: Segmentation Violation"
  end

  def install
    ENV.j1 # make won't run in parallel
    cd 'src' do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      system "make"
      system "make install-strip"
    end
  end
end
