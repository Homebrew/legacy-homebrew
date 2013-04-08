require 'base_kde_formula'

class Ksnakeduel < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ksnakeduel-4.10.2.tar.xz'
  sha1 'b359a1bfdcba0fdd872c27d0d94ddbd4e1726676'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ksnakeduel-4.10.2.tar.xz'
    sha1 'b359a1bfdcba0fdd872c27d0d94ddbd4e1726676'
  end

  depends_on 'kdelibs'
end
