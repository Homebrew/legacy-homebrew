require 'base_kde_formula'

class Ark < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ark-4.10.2.tar.xz'
  sha1 '3927eec73d2f1d1c9cd7b0d8888047df0bfb04ff'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ark-4.10.2.tar.xz'
    sha1 '3927eec73d2f1d1c9cd7b0d8888047df0bfb04ff'
  end

  depends_on 'kdelibs'
end
