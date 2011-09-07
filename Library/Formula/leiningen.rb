require 'formula'

class Leiningen < Formula
  url 'http://github.com/technomancy/leiningen/tarball/1.6.1'
  head 'http://github.com/technomancy/leiningen.git', :using => :git
  homepage 'http://github.com/technomancy/leiningen'
  md5 '97ae6d4842c2ac3d5d80db96332a2040'

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
