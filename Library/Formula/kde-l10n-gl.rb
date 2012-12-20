require 'base_kde_formula'

class KdeL10nGl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-gl-4.9.4.tar.xz'
  sha1 '6a20c562d11787bb9d2ce3ece7665e3a8e3e11fe'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-gl-4.9.95.tar.xz'
    sha1 'dc870d0f28aafa7e358671f969502c70760d6106'
  end

  depends_on 'kdelibs'
end
