require 'base_kde_formula'

class Ktouch < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/ktouch-4.9.4.tar.xz'
  sha1 '3b8c0ee5d81caa004f628a3bb660c9ed0f38df73'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/ktouch-4.9.95.tar.xz'
    sha1 'cc077ce192792492cb1438540c6d4e2da8bda42c'
  end

  depends_on 'kdelibs'
end
