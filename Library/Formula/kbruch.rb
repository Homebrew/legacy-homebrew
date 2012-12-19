require 'base_kde_formula'

class Kbruch < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kbruch-4.9.4.tar.xz'
  sha1 '77a1ba76f67b4d353efc2733ffb65873f4f24f45'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kbruch-4.9.95.tar.xz'
    sha1 '899f22d3693111a36d92dad368fe6feac21f9946'
  end

  depends_on 'kdelibs'
end
