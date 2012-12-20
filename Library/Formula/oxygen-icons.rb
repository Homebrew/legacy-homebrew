require 'base_kde_formula'

class OxygenIcons < BaseKdeFormula
  homepage 'http://www.oxygen-icons.org'
  url 'http://download.kde.org/stable/4.9.4/src/oxygen-icons-4.9.4.tar.xz'
  sha1 '459c0db3412e7f3aa3908467cbc6d9bc7af04c07'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/oxygen-icons-4.9.95.tar.xz'
    sha1 'ab58b38d8d691d55578c5ad33ed0e5220f2906b1'
  end

end
