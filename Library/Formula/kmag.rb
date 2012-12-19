require 'base_kde_formula'

class Kmag < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kmag-4.9.4.tar.xz'
  sha1 '725825a4a54180eb8fe4e405e08808988e09fdc4'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kmag-4.9.95.tar.xz'
    sha1 '631343e7fab106191dde5406cd48d2f65b37dbd2'
  end

  depends_on 'kdelibs'
end
