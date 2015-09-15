class Uru < Formula
  desc "Use multiple rubies on multiple platforms"
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.8.0.tar.gz"
  sha256 "7201ee957ad35131f6461ca35cc0fe77ca8e38d4e1603bad02871f5222413ee4"

  bottle do
    cellar :any
    sha1 "9476d70ca74e2074129067a8b820065ec7e7a86b" => :yosemite
    sha1 "61e905c6a60df009190c87afb830536e53419cdd" => :mavericks
    sha1 "6353400d611ed746f6f232a86c8ba8a18e89a06a" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/bitbucket.org/jonforums/uru").install Dir["*"]
    system "go", "build", "-ldflags", "-s", "bitbucket.org/jonforums/uru/cmd/uru"
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
