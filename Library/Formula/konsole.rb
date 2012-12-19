require 'base_kde_formula'

class Konsole < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/konsole-4.9.4.tar.xz'
  sha1 '64862dd9d6544f21d62b89b8b829c3ffaa2dafb7'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/konsole-4.9.95.tar.xz'
    sha1 '82b53c44e05d01620102ae27a80f7f4885e2213a'
  end

  depends_on 'kdelibs'
end
