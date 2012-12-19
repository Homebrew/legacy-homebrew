require 'base_kde_formula'

class Kcharselect < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kcharselect-4.9.4.tar.xz'
  sha1 '6f2c822e8255a87ad1636265c47ac78b366ce0db'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kcharselect-4.9.95.tar.xz'
    sha1 '7cb85f9baf763165d5231e70bd4c87af039eec46'
  end

  depends_on 'kdelibs'
end
