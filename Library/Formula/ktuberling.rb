require 'base_kde_formula'

class Ktuberling < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ktuberling-4.10.2.tar.xz'
  sha1 'e2431b70470c37b9f46514fc62932ac7f225f6b7'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ktuberling-4.10.2.tar.xz'
    sha1 'e2431b70470c37b9f46514fc62932ac7f225f6b7'
  end

  depends_on 'kdelibs'
end
