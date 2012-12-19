require 'base_kde_formula'

class Mplayerthumbs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/mplayerthumbs-4.9.4.tar.xz'
  sha1 '9c5073216f0b62e0fefbd5fbd1fa0e4889a9da1d'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/mplayerthumbs-4.9.95.tar.xz'
    sha1 '0f13371b701211ef3b4efe18ba96bddfde5c77ed'
  end

  depends_on 'kdelibs'
end
