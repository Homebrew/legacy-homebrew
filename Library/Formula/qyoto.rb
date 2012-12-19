require 'base_kde_formula'

class Qyoto < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/qyoto-4.9.4.tar.xz'
  sha1 '53715ebadb0d591d5a0913602dff7a92eb636e95'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/qyoto-4.9.95.tar.xz'
    sha1 '01a144330f4200d11be171715845bc794a2293e7'
  end

  depends_on 'kdelibs'
end
