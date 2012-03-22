require 'formula'

class Phpsh < Formula
  homepage ''
  url 'git://github.com/facebook/phpsh.git'
  version "1.0"
  depends_on 'python'
  def install
    system "python","setup.py", "install","--prefix=#{prefix}"
    bin.mkpath
    man1.install ['src/doc/phpsh.1']  
    system "rm","-rf","#{prefix}/man"
    system "ln","-s","-f","#{HOMEBREW_PREFIX}/share/python/phpsh","#{prefix}/bin/phpsh"
    bin.install ['src/phpsh']
    end
  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test phpsh`.
    system "false"
  end
end
