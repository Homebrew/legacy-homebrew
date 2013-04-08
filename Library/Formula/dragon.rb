require 'base_kde_formula'

class Dragon < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/dragon-4.10.2.tar.xz'
  sha1 'e4abf7618516e25d8943700d4509212c43ef67a1'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/dragon-4.10.2.tar.xz'
    sha1 'e4abf7618516e25d8943700d4509212c43ef67a1'
  end

  depends_on 'kdelibs'
end
