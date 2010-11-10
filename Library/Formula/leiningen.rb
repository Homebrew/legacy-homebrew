require 'formula'

class Leiningen <Formula
  url 'https://github.com/technomancy/leiningen/tarball/1.3.1'
  head 'https://github.com/technomancy/leiningen.git', :using => :git
  homepage 'https://github.com/technomancy/leiningen'
  md5 '707fb0da7b89b44d9d37a9bac2bf3b3f'

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
