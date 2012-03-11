require 'base_kde_formula'

class Ukhangman < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/khangman-4.8.1.tar.xz'
  sha1 '102eb6edec5f2c6f6f9086c6fb2136a6550cdef1'

  depends_on 'kdelibs'
end


