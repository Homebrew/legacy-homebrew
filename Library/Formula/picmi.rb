require 'base_kde_formula'

class Picmi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/picmi-4.10.2.tar.xz'
  sha1 '04a01a90bce152759c8f638b780df22fe6266c1c'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/picmi-4.10.2.tar.xz'
    sha1 '04a01a90bce152759c8f638b780df22fe6266c1c'
  end

  depends_on 'kdelibs'
end
