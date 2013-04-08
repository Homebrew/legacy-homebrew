require 'base_kde_formula'

class KdeBaseArtwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-base-artwork-4.10.2.tar.xz'
  sha1 '4071b07ebe544e7ec9032cf7fc2798eaa45ee39b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-base-artwork-4.10.2.tar.xz'
    sha1 '4071b07ebe544e7ec9032cf7fc2798eaa45ee39b'
  end

  depends_on 'kdelibs'
end
