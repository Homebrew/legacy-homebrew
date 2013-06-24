require 'formula'

class Funcoeszz < Formula
  homepage 'http://funcoeszz.googlecode.com/'
  url 'http://funcoeszz.net/download/funcoeszz-13.2.sh'
  sha1 '33d6950dc83fd2118bc45a752c4a77be3b112573'

  def install
    prefix.install "funcoeszz-#{version}.sh"
  end

  def caveats; <<-EOS.undent
    To use this software add to your profile:
      source #{opt_prefix}/funcoeszz-#{version}.sh
    EOS
  end
end
