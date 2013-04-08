require 'base_kde_formula'

class Kwallet < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kwallet-4.10.2.tar.xz'
  sha1 '2a566c85aec79e8d08afe996224029714cd38b6e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kwallet-4.10.2.tar.xz'
    sha1 '2a566c85aec79e8d08afe996224029714cd38b6e'
  end

  depends_on 'kdelibs'
end
