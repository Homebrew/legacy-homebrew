require 'base_kde_formula'

class AudiocdKio < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/audiocd-kio-4.10.2.tar.xz'
  sha1 '83d5f79e60b2b867047fd36f7a33af70087581d5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/audiocd-kio-4.10.2.tar.xz'
    sha1 '83d5f79e60b2b867047fd36f7a33af70087581d5'
  end

  depends_on 'kdelibs'
end
