require 'base_kde_formula'

class Kajongg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kajongg-4.10.2.tar.xz'
  sha1 'efda22fb18c5cbf87975be2f96a89a7ece6a2b9e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kajongg-4.10.2.tar.xz'
    sha1 'efda22fb18c5cbf87975be2f96a89a7ece6a2b9e'
  end

  depends_on 'kdelibs'
end
