class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "http://golo-lang.org"
  url "https://bintray.com/artifact/download/golo-lang/downloads/golo-3.0.0-incubation.zip"
  sha256 "e7d350148a3a7492348f0214679b282858ced58e4063a17bbf53f9ec2ae5f288"

  devel do
    url "https://bintray.com/artifact/download/golo-lang/downloads/golo-incubation-3.1.0-M2.zip"
    sha256 "ffc8789c23c5d38fed3da246ec0741d9fc265a5d51d56b75a56046264ef90975"
    version "3.1.0-incubation-M2"
  end

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
