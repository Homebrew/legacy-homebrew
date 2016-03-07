class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.13.0.tar.gz"
  sha256 "abada1d7bd411dca52ac0df2124a188d61301bdcd1fc75e8419a24496ee8ff42"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "3c6704cfff8e64b40c1446a02ac881e7c24c08bca005856b465df57896389f37" => :el_capitan
    sha256 "5befdddc3c7625074f7146d4d97e2a96f05c357ef6439c507d2d38a8794d5ce4" => :yosemite
    sha256 "8a06de0e04c0e4dc61925e43dc960a31e1329776e33905ce2e36df366ae143af" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.12.0/crystal-0.12.0-1-darwin-x86_64.tar.gz"
    version "0.12.0"
    sha256 "2481282c037d9b209ec44a98a01895c26c1f5eee33ad364d68bc15b834f63446"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.2.tar.gz"
    sha256 "11d22086d736598efa87eea558e7b304d538372f017fce9bb21476e40c586110"
  end

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
      system "make", "deps"
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
