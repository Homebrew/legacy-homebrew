require 'base_kde_formula'

class Ffmpegthumbs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/ffmpegthumbs-4.9.4.tar.xz'
  sha1 '6886d4949ebbb292bcbbfb28e254b561306ec3e8'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/ffmpegthumbs-4.9.95.tar.xz'
    sha1 '9dd421b6ec6e6bc20f9d6324c103c5bcdd277cbd'
  end

  depends_on 'kdelibs'
end
