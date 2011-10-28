require 'formula'

class Leiningen < Formula
  url 'http://github.com/technomancy/leiningen/tarball/1.6.1.1'
  homepage 'http://github.com/technomancy/leiningen'
  md5 'dbd6ac1df529e1e3b84814b8c44265ed'

  head 'https://github.com/technomancy/leiningen.git', :using => :git

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
