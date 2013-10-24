require 'formula'

class GnuProlog < Formula
  homepage 'http://www.gprolog.org/'
  url 'http://gprolog.univ-paris1.fr/gprolog-1.4.4.tar.gz'
  sha1 '658b0efa5d916510dcddbbd980d90bc4d43a6e58'

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
