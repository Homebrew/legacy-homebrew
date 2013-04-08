require 'base_kde_formula'

class Jovie < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/jovie-4.10.2.tar.xz'
  sha1 '3292fb9a1bbae4cfe2e37073b004f78e23936f6d'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/jovie-4.10.2.tar.xz'
    sha1 '3292fb9a1bbae4cfe2e37073b004f78e23936f6d'
  end

  depends_on 'kdelibs'
end
