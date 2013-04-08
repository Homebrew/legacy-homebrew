require 'base_kde_formula'

class Granatier < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/granatier-4.10.2.tar.xz'
  sha1 '36ac5fe97d2ea06038f0a2f7e58d0949a6d72cd8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/granatier-4.10.2.tar.xz'
    sha1 '36ac5fe97d2ea06038f0a2f7e58d0949a6d72cd8'
  end

  depends_on 'kdelibs'
end
