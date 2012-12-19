require 'base_kde_formula'

class Kdf < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdf-4.9.4.tar.xz'
  sha1 '57398080e2ae4fe61855ed6f576700fdde83a277'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdf-4.9.95.tar.xz'
    sha1 'f50e9e115ad1c8458d7bc1e2dc991a701ecd144c'
  end

  depends_on 'kdelibs'
end
