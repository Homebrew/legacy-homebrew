require 'base_kde_formula'

class Kremotecontrol < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kremotecontrol-4.9.4.tar.xz'
  sha1 '5aaab53ed9b6e4acd3618dc5265b52b3386c8c65'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kremotecontrol-4.9.95.tar.xz'
    sha1 '459bb83ba291b8dc47d0c971577aaf3a08bc1f84'
  end

  depends_on 'kdelibs'
end
