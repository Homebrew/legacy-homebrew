require 'base_kde_formula'

class Marble < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/marble-4.9.4.tar.xz'
  sha1 '32631172148b5994e81ba51dddf0e5bbd2a1867c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/marble-4.9.95.tar.xz'
    sha1 'f790b6de61d5ebe28d047baad3b2e00cfd06139b'
  end

  depends_on 'kdelibs'
end
