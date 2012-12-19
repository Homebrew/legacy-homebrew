require 'base_kde_formula'

class Smokegen < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/smokegen-4.9.4.tar.xz'
  sha1 '15dd451d602d12e045f3618f9debded16ea45ceb'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/smokegen-4.9.95.tar.xz'
    sha1 '7fb2756fc1536681aa0c47be8e88e85931011249'
  end

  depends_on 'kdelibs'
end
