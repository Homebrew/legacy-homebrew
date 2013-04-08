require 'base_kde_formula'

class Qtruby < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/qtruby-4.10.2.tar.xz'
  sha1 '5db91d696af4c9bcb784921ff7aa937bbc38ed01'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/qtruby-4.10.2.tar.xz'
    sha1 '5db91d696af4c9bcb784921ff7aa937bbc38ed01'
  end

  depends_on 'kdelibs'
end
