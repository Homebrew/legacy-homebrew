require 'formula'

class Newlisp <Formula
  url 'http://www.newlisp.org/downloads/newlisp-10.2.8.tgz'
  homepage 'http://www.newlisp.org/'
  md5 '4b728ce4d25cc6cbb4f53f8c98a02733'

  depends_on 'readline'

  def install
    # Minimal install as describe in the README
    system "./configure"
    system "make"

    bin.install 'newlisp'
  end

  def caveats; <<-EOS.undent
    Because of hardcoded paths in the newLISP source,
    this formula does not install the Java-based IDE.
    EOS
  end
end
