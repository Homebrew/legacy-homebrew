require 'base_kde_formula'

class KrossInterpreters < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kross-interpreters-4.10.2.tar.xz'
  sha1 '70726de496531b50010156b224bc807b72f85441'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kross-interpreters-4.10.2.tar.xz'
    sha1 '70726de496531b50010156b224bc807b72f85441'
  end

  depends_on 'kdelibs'
end
