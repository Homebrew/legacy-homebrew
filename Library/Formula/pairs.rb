require 'base_kde_formula'

class Pairs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/pairs-4.9.4.tar.xz'
  sha1 '9395abdc41127721782a9c565c2176a74e37b165'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/pairs-4.9.95.tar.xz'
    sha1 'b4a894bd1ad00c80ed8de422d0ee0e0304ca3f47'
  end

  depends_on 'kdelibs'
end
