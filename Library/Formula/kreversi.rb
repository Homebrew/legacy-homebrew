require 'base_kde_formula'

class Kreversi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kreversi-4.10.2.tar.xz'
  sha1 'a79e1b20849e419037c28febad0422a634a0585b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kreversi-4.10.2.tar.xz'
    sha1 'a79e1b20849e419037c28febad0422a634a0585b'
  end

  depends_on 'kdelibs'
end
