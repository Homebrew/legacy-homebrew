require 'base_kde_formula'

class Ktimer < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/ktimer-4.9.4.tar.xz'
  sha1 'eb0a962643bade40039b06fcf3d4d8a5eb1b9444'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/ktimer-4.9.95.tar.xz'
    sha1 '5b77c8be0b223bce6012f5d48f937ec487059208'
  end

  depends_on 'kdelibs'
end
