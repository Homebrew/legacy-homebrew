require 'formula'

class Stk < Formula
  homepage 'https://ccrma.stanford.edu/software/stk/'
  url 'http://ccrma.stanford.edu/software/stk/release/stk-4.4.4.tar.gz'
  sha1 '2a94f02ed054d3b991352cc68a85a0a8063e3a4b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"

    lib.install 'src/libstk.a'
    bin.install 'bin/treesed'

    (include/'stk').install Dir['include/*']
    doc.install Dir['doc/*']
    (share/'stk').install 'projects', 'rawwaves'
  end
end
