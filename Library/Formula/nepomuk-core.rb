require 'base_kde_formula'

class NepomukCore < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/nepomuk-core-4.9.4.tar.xz'
  sha1 'f48b29dbbaec3938930176d3225fe292c26c9fce'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/nepomuk-core-4.9.95.tar.xz'
    sha1 '98bee83019e469e28772da24cbec05d7744e6e44'
  end

  depends_on 'kdelibs'
end
