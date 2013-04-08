require 'base_kde_formula'

class KdeBaseapps < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-baseapps-4.10.2.tar.xz'
  sha1 '7f505292e95b35205cec3baa67e9e9b24f79b9b9'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-baseapps-4.10.2.tar.xz'
    sha1 '7f505292e95b35205cec3baa67e9e9b24f79b9b9'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
