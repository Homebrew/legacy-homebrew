require 'base_kde_formula'

class Kdepim < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdepim-4.10.2.tar.xz'
  sha1 '61b74cb3bf541040e09252d4dcfaea8a876a2859'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdepim-4.10.2.tar.xz'
    sha1 '61b74cb3bf541040e09252d4dcfaea8a876a2859'
  end

  depends_on 'kdepimlibs'
end
