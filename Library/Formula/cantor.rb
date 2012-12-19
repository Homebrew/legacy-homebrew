require 'base_kde_formula'

class Cantor < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/cantor-4.9.4.tar.xz'
  sha1 'fe77d1fcb0fe0368a4030adebb43aa9323f26f1c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/cantor-4.9.95.tar.xz'
    sha1 '757a9dafc33e18962ba88114be5438058946b99c'
  end

  depends_on 'kdelibs'
end
