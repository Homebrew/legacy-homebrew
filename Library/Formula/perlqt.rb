require 'base_kde_formula'

class Uperlqt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/perlqt-4.8.1.tar.xz'
  sha1 '119bbce5e82a47c8f70a8a124b73aa1cacf646ff'

  depends_on 'kdelibs'
end


