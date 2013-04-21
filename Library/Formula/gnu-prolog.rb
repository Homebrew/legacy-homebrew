require 'formula'

class GnuProlog < Formula
  homepage 'http://www.gprolog.org/'
  url 'http://www.gprolog.org/gprolog-1.4.3.tar.gz'
  sha1 'f91753a10f8ebc53d7298c767aaa9541a1209c5f'

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
