require 'formula'

class Matlab2tikz < Formula
  homepage 'https://github.com/nschloe/matlab2tikz'
  url 'https://github.com/nschloe/matlab2tikz/archive/0.4.0.tar.gz'
  sha1 '9c54e78a3f0278c9f346703856bbd91aa142ea21'

  head 'https://github.com/nschloe/matlab2tikz.git'

  def install
    (share/'matlab2tikz').install Dir['src/*']
  end
end
