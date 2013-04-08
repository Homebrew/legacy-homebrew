require 'base_kde_formula'

class NepomukWidgets < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/nepomuk-widgets-4.10.2.tar.xz'
  sha1 '2aa9eaf4709acc1f9a2acf6c6bb4b42fc0840549'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/nepomuk-widgets-4.10.2.tar.xz'
    sha1 '2aa9eaf4709acc1f9a2acf6c6bb4b42fc0840549'
  end

  depends_on 'kdelibs'
end
