require "formula"

class Uru < Formula
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.7.6.tar.gz"
  sha1 "c1618f861c94318004cdede66946f31436b410e7"

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
