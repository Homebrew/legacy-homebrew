require 'formula'

class Leiningen < Formula
  url 'http://github.com/technomancy/leiningen/tarball/1.6.0'
  head 'http://github.com/technomancy/leiningen.git', :using => :git
  homepage 'http://github.com/technomancy/leiningen'
  md5 '0e418df7de6a99b09e8b476f24059e2a'

  def install
    bin.install "bin/lein"
    system "#{bin}/lein self-install"

    # Install the lein bash completion file
    (etc+'bash_completion.d').install 'bash_completion.bash' => 'lein-completion.bash'
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
