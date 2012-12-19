require 'base_kde_formula'

class Kscd < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kscd-4.9.4.tar.xz'
  sha1 '298472d76a84a9c7f46c27cc7c141c90e1a1fae5'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kscd-4.9.95.tar.xz'
    sha1 '1d80e1ad8255a290596779fad7e557fe6fc69e23'
  end

  depends_on 'kdelibs'
end
