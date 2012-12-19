require 'base_kde_formula'

class Audiocd-kio < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/audiocd-kio-4.9.4.tar.xz'
  sha1 'f3ad5a8d8f4663ea0ea9d67834498350e932f57e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/audiocd-kio-4.9.95.tar.xz'
    sha1 'bf116156ff1f671aa398de0f4d3641ce321d1a06'
  end

  depends_on 'kdelibs'
end
