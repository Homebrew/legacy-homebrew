require 'base_kde_formula'

class Kwordquiz < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kwordquiz-4.10.2.tar.xz'
  sha1 'e21947d795f1025ee7766ac9c47bbe879b5d1a0e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kwordquiz-4.10.2.tar.xz'
    sha1 'e21947d795f1025ee7766ac9c47bbe879b5d1a0e'
  end

  depends_on 'kdelibs'
end
