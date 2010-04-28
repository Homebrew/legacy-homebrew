require 'formula'

class Newlisp <Formula
  url 'http://www.newlisp.org/downloads/newlisp-10.2.1.tgz'
  homepage 'http://www.newlisp.org/'
  md5 '27c51c0b95bdf0433e82eeff6010e93a'

  depends_on 'readline'

  def install
    # Minimal install as describe in the README
    system "./configure"
    system "make"

    bin.install 'newlisp'
  end

  def caveats; <<-EOS
    Because of hardcoded paths in the newLISP source,
    this formula does not install the Java-based IDE.
    EOS
  end
end
