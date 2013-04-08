require 'base_kde_formula'

class Libkexiv2 < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkexiv2-4.10.2.tar.xz'
  sha1 '02dce6eaf48c14f134f220eeed494d74d41f7226'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkexiv2-4.10.2.tar.xz'
    sha1 '02dce6eaf48c14f134f220eeed494d74d41f7226'
  end

  depends_on 'kdelibs'
  depends_on 'exiv2'
end
