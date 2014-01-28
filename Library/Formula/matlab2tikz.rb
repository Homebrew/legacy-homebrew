require 'formula'

class Matlab2tikz < Formula
  homepage 'https://github.com/nschloe/matlab2tikz'
  url 'https://github.com/nschloe/matlab2tikz/archive/0.4.4.tar.gz'
  sha1 '9477dae6bd0ba5b268a1d5d7f547ad631638a99f'

  head 'https://github.com/nschloe/matlab2tikz.git'

  def install
    (share/'matlab2tikz').install Dir['src/*']
  end
end
