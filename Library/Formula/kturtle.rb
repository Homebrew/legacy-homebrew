require 'base_kde_formula'

class Kturtle < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kturtle-4.9.4.tar.xz'
  sha1 '4c0b1725b68a93b55ea53aff8b9393f10cfd8792'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kturtle-4.9.95.tar.xz'
    sha1 '0cf2e23eb1700c10c88a31c0edc33919fac3b27c'
  end

  depends_on 'kdelibs'
end
