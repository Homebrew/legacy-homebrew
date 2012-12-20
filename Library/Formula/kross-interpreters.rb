require 'base_kde_formula'

class KrossInterpreters < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kross-interpreters-4.9.4.tar.xz'
  sha1 '01e1a4f37898e1170e5827d07f4e6ed34ab8ea6d'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kross-interpreters-4.9.95.tar.xz'
    sha1 '7d46e9eb28e630a06a073ae36f359dd84c1c9a2f'
  end

  depends_on 'kdelibs'
end
