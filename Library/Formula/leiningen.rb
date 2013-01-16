require 'formula'

class Leiningen < Formula
  homepage 'http://github.com/technomancy/leiningen'
  url 'http://github.com/technomancy/leiningen/tarball/1.7.1'
  sha1 '80361e88cc5a88553d64e0d98ef542ab74b7148f'

  head 'https://github.com/technomancy/leiningen.git'

  devel do
    url 'https://github.com/technomancy/leiningen/tarball/2.0.0-RC2'
    version '2.0.0-RC2'
    sha1 '71e47c8686c0148532738a7ee56df83757382607'
  end

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
