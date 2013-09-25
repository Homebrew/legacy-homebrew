require 'formula'

class Matlab2tikz < Formula
  homepage 'https://github.com/nschloe/matlab2tikz'
  url 'https://github.com/nschloe/matlab2tikz/archive/0.4.2.tar.gz'
  sha1 '70ff455c6171aaee729301619ce4069c97d4342f'

  head 'https://github.com/nschloe/matlab2tikz.git'

  def install
    (share/'matlab2tikz').install Dir['src/*']
  end
end
