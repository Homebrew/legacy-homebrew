class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "http://golo-lang.org"
  url "https://bintray.com/artifact/download/golo-lang/downloads/golo-3.1.0.zip"
  sha256 "a684a089a808b29d42a4aa972db74c000c7686d32031764da8ab0c11a2b97820"

  head do
    url "https://github.com/eclipse/golo-lang.git"
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    if build.head?
      system "./gradlew", "installDist"
      libexec.install %w[build/install/golo/bin build/install/golo/docs build/install/golo/lib]
    else
      libexec.install %w[bin docs lib]
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
