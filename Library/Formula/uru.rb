class Uru < Formula
  desc "Use multiple rubies on multiple platforms"
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.8.1.tar.gz"
  sha256 "169cfaa2982be8ee6e58dbbf90a92fb57e14f99e943d223c3c5e2d4bab0b6c46"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c616c324409575a681c156bdfbbecffdb55f6d4c59a664a5a0231c7373e1489" => :el_capitan
    sha256 "979224d18653ddbdff2922af2cff156274904a75d40f5dab1263726cd6126228" => :yosemite
    sha256 "f68f12bb741ba6483268c6a8721368589db150d058919c76117ff7bd5ca15f26" => :mavericks
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
