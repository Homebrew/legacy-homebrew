require 'base_kde_formula'

class Step < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/step-4.10.2.tar.xz'
  sha1 'ff5fccd47113b598b688b87226b23072047bf990'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/step-4.10.2.tar.xz'
    sha1 'ff5fccd47113b598b688b87226b23072047bf990'
  end

  depends_on 'kdelibs'
end
