require 'base_kde_formula'

class Kgamma < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kgamma-4.9.4.tar.xz'
  sha1 '04c9d79cb49d2ee8488a4f343945f3b4ead4b183'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kgamma-4.9.95.tar.xz'
    sha1 'e1f49a529a058f022953a09da7eb8b7c6c7b853a'
  end

  depends_on 'kdelibs'
end
