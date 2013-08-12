require 'formula'

class LeiningenJar < Formula
  url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.0-standalone.jar', :using => :nounzip
  sha1 '17d7347a8bee5ee34c6191ded0af0f8d6b348319'
end

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.3.0.tar.gz'
  sha1 'f19921fb05b5313a6ea654602e015ca9ed8ece9b'

  head 'https://github.com/technomancy/leiningen.git'

  def install
    LeiningenJar.new.brew { libexec.install "leiningen-#{version}-standalone.jar" }
    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! 'LEIN_JAR', libexec/"leiningen-#{version}-standalone.jar"
    end
    bin.install "bin/lein-pkg" => 'lein'
    bash_completion.install 'bash_completion.bash' => 'lein-completion.bash'
    zsh_completion.install 'zsh_completion.zsh' => '_lein'
  end

  def caveats; <<-EOS.undent
    Dependencies will be installed to:
      $HOME/.m2/repository
    EOS
  end
end
