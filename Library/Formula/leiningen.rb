require 'formula'

class Leiningen < Formula
  url 'http://github.com/technomancy/leiningen/tarball/1.5.0'
  head 'http://github.com/technomancy/leiningen.git', :using => :git
  homepage 'http://github.com/technomancy/leiningen'
  md5 '556aa625eda7bd57b15c44046e141eaa'

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
