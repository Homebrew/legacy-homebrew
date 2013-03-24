require 'formula'

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.1.1.tar.gz'
  sha1 '19330ac159772a22237d6bff1345f22f0b1677e5'

  head 'https://github.com/technomancy/leiningen.git'

  def install
    bin.install "bin/lein"
    system "#{bin}/lein", "self-install"
    (etc+'bash_completion.d').install 'bash_completion.bash' => 'lein-completion.bash'
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
