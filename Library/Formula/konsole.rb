require 'base_kde_formula'

class Konsole < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/konsole-4.10.2.tar.xz'
  sha1 '171824f4d06c66a4373274da01cad84853bec821'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/konsole-4.10.2.tar.xz'
    sha1 '171824f4d06c66a4373274da01cad84853bec821'
  end

  depends_on 'kdelibs'
end
