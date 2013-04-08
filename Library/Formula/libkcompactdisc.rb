require 'base_kde_formula'

class Libkcompactdisc < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkcompactdisc-4.10.2.tar.xz'
  sha1 'dcd95e3b197a871a21cd50f70edc5039b7835ef4'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkcompactdisc-4.10.2.tar.xz'
    sha1 'dcd95e3b197a871a21cd50f70edc5039b7835ef4'
  end

  depends_on 'kdelibs'
end
