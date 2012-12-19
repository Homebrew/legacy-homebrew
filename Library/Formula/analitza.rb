require 'base_kde_formula'

class Analitza < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/analitza-4.9.4.tar.xz'
  sha1 '4bc60c937d881eb11491b30ae445ebc37393a303'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/analitza-4.9.95.tar.xz'
    sha1 '279fa3fac98bbf5fc33f59714cbd4b822d65c320'
  end

  depends_on 'kdelibs'
end
