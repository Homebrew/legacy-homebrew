require 'base_kde_formula'

class Sweeper < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/sweeper-4.9.4.tar.xz'
  sha1 '5c0e489a470174a61a6bea88ac994e555ebdd1c9'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/sweeper-4.9.95.tar.xz'
    sha1 '036ae7d74e4e7a464a060424a7972c9b7ceeb486'
  end

  depends_on 'kdelibs'
end
