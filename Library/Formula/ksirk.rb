require 'base_kde_formula'

class Ksirk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ksirk-4.10.2.tar.xz'
  sha1 'd64786e76fa87f8f99962a3676c82ae48f3e7841'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ksirk-4.10.2.tar.xz'
    sha1 'd64786e76fa87f8f99962a3676c82ae48f3e7841'
  end

  depends_on 'kdelibs'
end
