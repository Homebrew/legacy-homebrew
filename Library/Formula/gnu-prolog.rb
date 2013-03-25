require 'formula'

class GnuProlog < Formula
  homepage 'http://www.gprolog.org/'
  url 'http://www.gprolog.org/gprolog-1.4.2.tar.gz'
  sha1 '76d366910e50e56aa06c98a0a8903f98ec7f1c21'

  fails_with :clang do
    cause "Fatal Error: Segmentation Violation"
  end

  def install
    ENV.j1 # won't make in parallel
    cd 'src' do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      system "make"
      system "make install-strip"
    end
  end
end
