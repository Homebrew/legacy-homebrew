require 'base_kde_formula'

class Libkipi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkipi-4.10.2.tar.xz'
  sha1 '3098759c56c8fa89bc087de60d8709c7f76dc7a6'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkipi-4.10.2.tar.xz'
    sha1 '3098759c56c8fa89bc087de60d8709c7f76dc7a6'
  end

  depends_on 'kdelibs'
end
