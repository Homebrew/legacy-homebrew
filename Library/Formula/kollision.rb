require 'base_kde_formula'

class Kollision < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kollision-4.10.2.tar.xz'
  sha1 '19f085adcf6477e4b69f554721e5a82a3754d8de'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kollision-4.10.2.tar.xz'
    sha1 '19f085adcf6477e4b69f554721e5a82a3754d8de'
  end

  depends_on 'kdelibs'
end
