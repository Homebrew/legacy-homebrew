require 'base_kde_formula'

class Kdenetwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdenetwork-4.10.2.tar.xz'
  sha1 '972526be8275a8adcb6e4fa51188a5dad83a0b14'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdenetwork-4.10.2.tar.xz'
    sha1 '972526be8275a8adcb6e4fa51188a5dad83a0b14'
  end

  depends_on 'kdelibs'
end
