require 'base_kde_formula'

class Okular < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/okular-4.10.2.tar.xz'
  sha1 'fcd0c725300c50ea04ec8e05b7d7035bf26afc79'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/okular-4.10.2.tar.xz'
    sha1 'fcd0c725300c50ea04ec8e05b7d7035bf26afc79'
  end

  depends_on 'kdelibs'
end
