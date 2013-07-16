require 'formula'
require 'tempfile'

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.2.0.tar.gz'
  sha1 '0ca7e4ea68b490171d869bd5cc3912feba8d7ee9'

  head 'https://github.com/technomancy/leiningen.git', :all => true

  def install
    if build.head?
      stable_lein = Tempfile.new "lein"
      File.chmod(0700, stable_lein)
      Dir.chdir(@downloader.cached_location) do
        stable_lein.write(`git show origin/stable:bin/lein`)
      end
      stable_lein.close

      Dir.chdir("leiningen-core") do
        system "#{stable_lein.path} bootstrap"
      end
    end

    bin.install "bin/lein"
    system "#{bin}/lein", "self-install" unless build.head?
    bash_completion.install 'bash_completion.bash' => 'lein-completion.bash'
    zsh_completion.install 'zsh_completion.zsh' => '_lein'

    File.unlink(stable_lein)
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
