require 'formula'

class Pyp < Formula
  head 'http://pyp.googlecode.com/svn/trunk'
  homepage 'http://opensource.imageworks.com/?p=pyp'

  def install
    bin.install "pyp"
  end

  def test
    system "echo a b c | pyp 'p.split() | u'"
  end
end
