require 'base_kde_formula'

class Jovie < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/jovie-4.9.4.tar.xz'
  sha1 'd490ee768aa59d263b7fd43d4b180193658aebbd'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/jovie-4.9.95.tar.xz'
    sha1 'cb9f087f8460ab6f20fc92f3b2f5537c0aefc4fc'
  end

  depends_on 'kdelibs'
end
