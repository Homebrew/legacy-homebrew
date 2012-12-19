require 'base_kde_formula'

class Kdeartwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdeartwork-4.9.4.tar.xz'
  sha1 '7ba38088117d172e54e66f480cc164509bc4628a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdeartwork-4.9.95.tar.xz'
    sha1 'f1ca98976d54af3edce7d7884865d9d5ab9bee5d'
  end

  depends_on 'kdelibs'
end
