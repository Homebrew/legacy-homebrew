require 'base_kde_formula'

class Libksane < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libksane-4.9.4.tar.xz'
  sha1 '6e6dd688b9cae1e809754d527327770c8a4caad0'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libksane-4.9.95.tar.xz'
    sha1 'c313f08f9782656ce8a6b1c4e588a1549cb195bc'
  end

  depends_on 'kdelibs'
end
