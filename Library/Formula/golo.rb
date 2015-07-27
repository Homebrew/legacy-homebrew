class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "http://golo-lang.org"
  url "https://repo1.maven.org/maven2/org/golo-lang/golo/2.1.0/golo-2.1.0-distribution.tar.gz"
  sha256 "59c7324b7eac88dfe2cb9612468cf5639ae0b84e44319b2ee617e0e054eed422"

  devel do
    url "https://www.eclipse.org/downloads/download.php?file=/golo/golo-3.0.0-incubation-M1-distribution.zip&r=1"
    sha256 "fd92e70e11a7c4dccd160b1236a0981cfa3cb22d8af190d177c5c4e909e020ae"
    version "3.0.0-incubation-M1"
    depends_on :java => "1.8+"
  end

  head do
    url "https://github.com/eclipse/golo-lang.git"
    depends_on "maven" => :build
    depends_on :java => "1.8+"
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
