require 'base_kde_formula'

class Kwallet < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kwallet-4.9.4.tar.xz'
  sha1 'd4dd33868ba75a3342ad380ea626e1ed2e8898d5'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kwallet-4.9.95.tar.xz'
    sha1 '19bd9630b03c486874e94ab9a2d2ec4d97309caf'
  end

  depends_on 'kdelibs'
end
