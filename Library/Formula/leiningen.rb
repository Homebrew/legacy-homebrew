require 'formula'

class Leiningen <Formula
  url 'http://github.com/technomancy/leiningen/tarball/1.1.0'
  homepage 'http://github.com/technomancy/leiningen'
  md5 '96c542751e19816be4676a859e1734b6'

  def install
    system "bin/lein self-install"
    prefix.install 'bin'

    # Install the lein bash completion file
    (etc+'bash_completion.d').install 'bash_completion.bash' => 'lein-completion.bash'
  end
end
