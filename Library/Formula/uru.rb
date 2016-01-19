class Uru < Formula
  desc "Use multiple rubies on multiple platforms"
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.8.1.tar.gz"
  sha256 "169cfaa2982be8ee6e58dbbf90a92fb57e14f99e943d223c3c5e2d4bab0b6c46"

  bottle do
    cellar :any_skip_relocation
    sha256 "c510cfeea72b21ce8928095a53bdc8176fda8210507ac12ac1c04cd55d7f4f43" => :el_capitan
    sha256 "505c30f4109b6436c8b27a6118de6fb122e79d24dffe8f6213829a9c307c25a9" => :yosemite
    sha256 "16b0fee7939e8d14d200ca565f5a977caf17c0c2444f1131320572c6ec7a359f" => :mavericks
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
