require 'base_kde_formula'

class Ukturtle < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kturtle-4.8.1.tar.xz'
  sha1 '3a6a3828c44957644716608234a3813690d0c503'

  depends_on 'kdelibs'
end


