require 'base_kde_formula'

class Qtruby < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/qtruby-4.9.4.tar.xz'
  sha1 '4f6f57b7f99b540b126534b8f9208cc1419b7e9a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/qtruby-4.9.95.tar.xz'
    sha1 '162e2bd2cd886e4b36321b22a5960b43de2dd46e'
  end

  depends_on 'kdelibs'
end
