require 'formula'

class Matlab2tikz < Formula
  homepage 'https://github.com/nschloe/matlab2tikz'
  url 'https://github.com/nschloe/matlab2tikz/archive/0.4.7.tar.gz'
  sha1 '0e950ae8a29d66610fc68b173f3a014e522ee1be'

  head 'https://github.com/nschloe/matlab2tikz.git'

  def install
    (share/'matlab2tikz').install Dir['src/*']
  end
end
