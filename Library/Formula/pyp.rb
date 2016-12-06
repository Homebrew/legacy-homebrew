require 'formula'

class Pyp < Formula
  url 'http://pyp.googlecode.com/svn/trunk', :revision => "216"
  homepage 'http://code.google.com/p/pyp/'
  version '2.10'

  def install
    bin.install Dir['pyp']
  end

  def test
      system "whoami | pyp 'p.upper()'"
  end

end
