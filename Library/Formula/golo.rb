require "formula"

class Golo < Formula
  homepage "http://golo-lang.org"
  url "http://search.maven.org/remotecontent?filepath=org/golo-lang/golo/1.1.0/golo-1.1.0-distribution.tar.gz"
  sha1 "ec0163eadbef21b88c7477bb7cfddc86ebe98b66"

  head do
    url "https://github.com/golo-lang/golo-lang.git"
    depends_on "maven"
  end

  depends_on :java => "1.7"

  def install
    if build.head?
      rake "special:bootstrap"
      libexec.install %w(target/appassembler/bin target/appassembler/lib)
    else
      libexec.install %w(bin doc lib)
    end
    libexec.install %w(share samples)

    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install "#{libexec}/share/shell-completion/golo-bash-completion"
    zsh_completion.install "#{libexec}/share/shell-completion/golo-zsh-completion" => "_golo"
    cp "#{bash_completion}/golo-bash-completion", zsh_completion
  end

  def caveats
    if ENV["SHELL"].include? "zsh"; <<-EOS.undent
For ZSH users, please add "golo" in yours plugins in ".zshrc"
      EOS
    end
  end
end
