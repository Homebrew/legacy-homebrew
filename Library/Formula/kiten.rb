require 'base_kde_formula'

class Kiten < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kiten-4.10.2.tar.xz'
  sha1 '7aa2d6889c932639ded77eac33b9ae09ed7bbc45'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kiten-4.10.2.tar.xz'
    sha1 '7aa2d6889c932639ded77eac33b9ae09ed7bbc45'
  end

  depends_on 'kdelibs'
end
