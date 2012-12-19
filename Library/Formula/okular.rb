require 'base_kde_formula'

class Okular < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/okular-4.9.4.tar.xz'
  sha1 '66299e7c61596e22109fe0758c1aab306e591d11'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/okular-4.9.95.tar.xz'
    sha1 '0cdd0ecc876153d8e32775a123cc53d594526304'
  end

  depends_on 'kdelibs'
end
