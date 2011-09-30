require 'formula'

class ClosureLinter < Formula
  url 'http://closure-linter.googlecode.com/files/closure_linter-2.3.2b.tar.gz'
  homepage 'http://code.google.com/closure/utilities/'
  md5 '432d27bad92067f3a0a63f898982508d'

  depends_on 'python'

  def install
    system "python", "setup.py", "install",
           "--prefix=#{HOMEBREW_PREFIX}"
  end
end
