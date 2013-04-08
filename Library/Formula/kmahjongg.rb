require 'base_kde_formula'

class Kmahjongg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmahjongg-4.10.2.tar.xz'
  sha1 'c54467341866d975a25529b70033bb0f45920d11'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmahjongg-4.10.2.tar.xz'
    sha1 'c54467341866d975a25529b70033bb0f45920d11'
  end

  depends_on 'kdelibs'
end
