class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "http://golo-lang.org"
  url "http://search.maven.org/remotecontent?filepath=org/golo-lang/golo/2.1.0/golo-2.1.0-distribution.tar.gz"
  sha1 "42bc1f44007b7aa4dfc85ad8da0a75918faf65fb"

  head do
    url "https://github.com/golo-lang/golo-lang.git"
    depends_on "maven" => :build
  end

  depends_on :java => "1.7+"

  def install
    if build.head?
      rake "special:bootstrap"
      libexec.install %w[target/appassembler/bin target/appassembler/lib]
    else
      libexec.install %w[bin doc lib]
    end
    libexec.install %w[share samples]

    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install "#{libexec}/share/shell-completion/golo-bash-completion"
    zsh_completion.install "#{libexec}/share/shell-completion/golo-zsh-completion" => "_golo"
    cp "#{bash_completion}/golo-bash-completion", zsh_completion
  end

  def caveats
    if ENV["SHELL"].include? "zsh"
      <<-EOS.undent
        For ZSH users, please add "golo" in yours plugins in ".zshrc"
      EOS
    end
  end

  test do
    system "#{bin}/golo", "golo", "--files", "#{libexec}/samples/helloworld.golo"
  end
end
