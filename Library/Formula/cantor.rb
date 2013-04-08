require 'base_kde_formula'

class Cantor < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/cantor-4.10.2.tar.xz'
  sha1 '7611cb379889f87908931ba25a2de9072de75e22'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/cantor-4.10.2.tar.xz'
    sha1 '7611cb379889f87908931ba25a2de9072de75e22'
  end

  depends_on 'kdelibs'
end
