require 'base_kde_formula'

class Kwordquiz < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kwordquiz-4.9.4.tar.xz'
  sha1 '81e9c87b19c14bf5c5e4dfce2e47fbed63ad0c99'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kwordquiz-4.9.95.tar.xz'
    sha1 'ebe6ac89b0e47f8e308a899194fe26ce3aad49c5'
  end

  depends_on 'kdelibs'
end
