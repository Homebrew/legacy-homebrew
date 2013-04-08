require 'base_kde_formula'

class Ksudoku < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ksudoku-4.10.2.tar.xz'
  sha1 '91fcb7a9daa58340a2e73131add8e78e3121ae9b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ksudoku-4.10.2.tar.xz'
    sha1 '91fcb7a9daa58340a2e73131add8e78e3121ae9b'
  end

  depends_on 'kdelibs'
end
