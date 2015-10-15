class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v0.8.0.tar.gz"
  sha256 "7a8037719feaa82966ef2633235a4a107c2302db3bdd147be98555616fff12cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb8b67b088be0c4dfe09a04c8fe31abf1c58f2feb8aecf08f2ca30b20ec1fe20" => :el_capitan
    sha256 "bc10898bc3927ea639d2b83fc3eddaeb9a152178ff66e3bab5d4263494dd11c5" => :yosemite
    sha256 "1a3544b8ba20c80726f857911959f9cc2f430fcf1d202fcc341fcbbdd8109c95" => :mavericks
  end

  def install
    libexec.install Dir["src/*"]
    bin.write_exec_script Dir["#{libexec}/git-*"]
    man1.install Dir["man/man1/*"]
  end

  def caveats; <<-EOS.undent
    To install the Fish shell autocompletions run:
      `git town install-fish-autocompletion`
    in your terminal.
  EOS
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
