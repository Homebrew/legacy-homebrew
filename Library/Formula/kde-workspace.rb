require 'base_kde_formula'

class KdeWorkspace < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-workspace-4.9.4.tar.xz'
  sha1 'c619181256f86bb1921cfbe6136ea3604d94aabe'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-workspace-4.9.95.tar.xz'
    sha1 '531a7c34da49df5d50c267fcd88cf82a216cca4b'
  end

  depends_on 'kdelibs'
end
