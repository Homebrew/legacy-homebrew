require 'base_kde_formula'

class Killbots < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/killbots-4.10.2.tar.xz'
  sha1 '87100f1fcb1e3547939406d6d4a4b8b2582831c8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/killbots-4.10.2.tar.xz'
    sha1 '87100f1fcb1e3547939406d6d4a4b8b2582831c8'
  end

  depends_on 'kdelibs'
end
