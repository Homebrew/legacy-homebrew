require 'formula'

class Turtle < Formula
  homepage 'http://sourceforge.net/projects/turtle/'
  url 'http://downloads.sourceforge.net/project/turtle/turtle/1.2.0/turtle-1.2.0.zip'
  sha1 '086ba98e67a49ebf5e2498c02e4e75484afb8398'

  depends_on 'boost'

  def install
    prefix.install Dir['*']
  end
end
