require 'formula'

class Matlab2tikz < Formula
  homepage 'https://github.com/nschloe/matlab2tikz'
  url 'https://github.com/nschloe/matlab2tikz/archive/0.4.1.tar.gz'
  sha1 '09f5ef71b8ee74abe526d029f896ca08779133a2'

  head 'https://github.com/nschloe/matlab2tikz.git'

  def install
    (share/'matlab2tikz').install Dir['src/*']
  end
end
