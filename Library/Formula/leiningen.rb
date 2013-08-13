require 'formula'

class LeiningenJar < Formula
  url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.1-standalone.jar'
  sha1 '08273a8842efa01582a4ecdb5586813b05e9fc48'
end

class Leiningen < Formula
  homepage 'https://github.com/technomancy/leiningen'
  url 'https://github.com/technomancy/leiningen/archive/2.3.1.tar.gz'
  sha1 '6da3237b93256857ddaa27ce7bb79870c6f6ee6e'

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
