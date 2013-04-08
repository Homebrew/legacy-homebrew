require 'base_kde_formula'

class Kdeadmin < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdeadmin-4.10.2.tar.xz'
  sha1 '885f63b846e9e8d1485c9261544efb2ab0eea58e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdeadmin-4.10.2.tar.xz'
    sha1 '885f63b846e9e8d1485c9261544efb2ab0eea58e'
  end

  depends_on 'kdelibs'
end
