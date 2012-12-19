require 'base_kde_formula'

class Libkexiv2 < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libkexiv2-4.9.4.tar.xz'
  sha1 '130c9956c89076ba9df971ea72c0713fdcfee989'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libkexiv2-4.9.95.tar.xz'
    sha1 '6f2ab9625abf99b9f78f959c0734b2b35b270662'
  end

  depends_on 'kdelibs'
  depends_on 'exiv2'
end
