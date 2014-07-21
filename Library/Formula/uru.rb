require "formula"

class Uru < Formula
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.7.4.tar.gz"
  sha1 "24b91db240e324d2738ad1f19079aed41b9cfdbf"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/bitbucket.org/jonforums/uru").install Dir["*"]
    system "go", "build", "-ldflags", "-s", "bitbucket.org/jonforums/uru"
    bin.install "uru" => "uru_rt"
  end

  def caveats; <<-EOS.undent
    Append to ~/.profile on Ubuntu, or to ~/.zshrc on Zsh
    $ echo 'eval "$(uru_rt admin install)"' >> ~/.bash_profile
    EOS
  end

  test do
    system "#{bin}/uru_rt"
  end
end
