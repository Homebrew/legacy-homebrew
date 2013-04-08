require 'base_kde_formula'

class KdeWorkspace < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-workspace-4.10.2.tar.xz'
  sha1 '12b10e8bea44f3aafa0c8d776eadfee14d71c3f8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-workspace-4.10.2.tar.xz'
    sha1 '12b10e8bea44f3aafa0c8d776eadfee14d71c3f8'
  end

  depends_on 'kdelibs'
end
