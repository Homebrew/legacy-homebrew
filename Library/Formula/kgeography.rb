require 'base_kde_formula'

class Kgeography < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kgeography-4.9.4.tar.xz'
  sha1 'eea64f1812eeb4987fe9a39dbb0a7d7bde5b2099'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kgeography-4.9.95.tar.xz'
    sha1 'f2d89cf07449a7cec69cb4e236d894be6657f649'
  end

  depends_on 'kdelibs'
end
