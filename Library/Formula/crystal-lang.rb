class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.11.1.tar.gz"
  sha256 "bdff81fcb4f2dfdd50d79abba8a1ed0260bad4c1f055002cd16b9b6f443b8a15"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "4959064393605908883e43cf3821aa3ad179f1ad85d3117d507205df5b458c0f" => :el_capitan
    sha256 "7f9fdf8cfcaedd95d8e63aeb62f7fdfbbea87edb12e3c6e2996bc6aec838cc74" => :yosemite
    sha256 "34129143f8f9e87d070d8b404a8e7cccd1229db85f3aae11f4dee01710da455b" => :mavericks
  end

  resource "boot" do
    url "https://github.com/manastech/crystal/releases/download/0.10.2/crystal-0.10.2-1-darwin-x86_64.tar.gz"
    sha256 "6b1ffdbb662a27b2da2bccb358aff7c7d01d6ae1b1636fd5a99a3d73de4b8f4b"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.0.tar.gz"
    sha256 "cbaaa6f9d9d140ec410623b97cb86fb44640125495f1e48fb8a1875ccedc4cc5"
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = `git rev-parse --short HEAD`.strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:libs"
    ENV.append_path "PATH", "boot/bin"

    if build.with? "release"
      system "make", "crystal", "release=true"
    else
      system "make", "llvm_ext"
      (buildpath/".build").mkpath
      system "bin/crystal", "build", "-o", ".build/crystal", "src/compiler/crystal.cr"
    end

    if build.with? "shards"
      resource("shards").stage do
        system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
      end
      bin.install ".build/shards"
    end

    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "crystal"
  end

  test do
    system "#{bin}/crystal", "eval", "puts 1"
  end
end
