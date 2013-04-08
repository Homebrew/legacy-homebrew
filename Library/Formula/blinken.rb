require 'base_kde_formula'

class Blinken < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/blinken-4.10.2.tar.xz'
  sha1 '884c9bd072325b3fc3e06da5c875516c6ee1f728'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/blinken-4.10.2.tar.xz'
    sha1 '884c9bd072325b3fc3e06da5c875516c6ee1f728'
  end

  depends_on 'kdelibs'
end
