require 'base_kde_formula'

class Libkdcraw < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libkdcraw-4.9.4.tar.xz'
  sha1 'b40cac622106dd45dd15e3ccc3b10480cc624bd8'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libkdcraw-4.9.95.tar.xz'
    sha1 '6384b2950de83e1151f45d7b0f615632d3b7b990'
  end

  depends_on 'kdelibs'
end
