require 'base_kde_formula'

class Superkaramba < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/superkaramba-4.10.2.tar.xz'
  sha1 '5c701c7d95cef873fd0767726a6042d02844c0f2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/superkaramba-4.10.2.tar.xz'
    sha1 '5c701c7d95cef873fd0767726a6042d02844c0f2'
  end

  depends_on 'kdelibs'
end
