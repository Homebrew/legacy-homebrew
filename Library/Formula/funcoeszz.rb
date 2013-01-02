require 'formula'

class Funcoeszz < Formula
  homepage 'http://funcoeszz.googlecode.com/'
  url 'http://funcoeszz.googlecode.com/files/funcoeszz-10.12.sh'
  sha1 'd9b8f5b131b844aee9ad429943472efe477cab5a'

  def install
    prefix.install "funcoeszz-10.12.sh"
  end

  def caveats; <<-EOS.undent
    To use this software add to your profile:
      source #{opt_prefix}/funcoeszz-10.12.sh
    EOS
  end
end
