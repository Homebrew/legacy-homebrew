require 'base_kde_formula'

class Juk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/juk-4.10.2.tar.xz'
  sha1 '4ffb1275369dfd645a99449705ba1651e9bd3885'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/juk-4.10.2.tar.xz'
    sha1 '4ffb1275369dfd645a99449705ba1651e9bd3885'
  end

  depends_on 'kdelibs'
end
