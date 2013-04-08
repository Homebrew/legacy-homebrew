require 'base_kde_formula'

class Kbruch < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kbruch-4.10.2.tar.xz'
  sha1 '2ba86ec27e9890734dc6a74528b6082f31caa8aa'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kbruch-4.10.2.tar.xz'
    sha1 '2ba86ec27e9890734dc6a74528b6082f31caa8aa'
  end

  depends_on 'kdelibs'
end
