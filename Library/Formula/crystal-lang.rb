class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.14.2.tar.gz"
  sha256 "0fdbb8c0ebbc1da0024b19fac193763654b474e3e2db957a4543bfc5ad5dba67"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "c6791c15e931c8c4894af36dfdd6689ff63a94677d0828772d5473443c62951d" => :el_capitan
    sha256 "25bc1c73b8a0fc24d66b66ceeab8a0a3a8674ea55fa3f94b9c54b212e17a2b42" => :yosemite
    sha256 "dac7f07a399532b349acf99095e51647c70754e9ef2565d3aed4465e1dd95008" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.13.0/crystal-0.13.0-1-darwin-x86_64.tar.gz"
    version "0.13.0"
    sha256 "06a9485240387ae145e6cad07889cd40a632b0f2a13aa33470b21f59e76a0680"
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
      system "bin/crystal", "build", "-o", "-D", "without_openssl", "-D", "without_zlib", ".build/crystal", "src/compiler/crystal.cr"
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
