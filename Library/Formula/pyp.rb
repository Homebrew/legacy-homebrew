require 'formula'

class Pyp < Formula
  homepage 'http://code.google.com/p/pyp/'
  url 'http://pyp.googlecode.com/svn/trunk', :revision => "216"
  version '2.10'

  def install
    bin.install 'pyp'
  end

  def test
    system "whoami | #{bin}/pyp 'p.upper()'"
  end
end
