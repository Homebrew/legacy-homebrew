require 'base_kde_formula'

class Ksnapshot < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ksnapshot-4.10.2.tar.xz'
  sha1 '4f3167a98d300a56abe91fb56785afc350439cbf'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ksnapshot-4.10.2.tar.xz'
    sha1 '4f3167a98d300a56abe91fb56785afc350439cbf'
  end

  depends_on 'kdelibs'
end
