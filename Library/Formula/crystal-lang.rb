class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.15.0.tar.gz"
  sha256 "d79445ec92faa2a045af150fca4886d90ecd9fba27451003b68118c8714b26bd"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "ad7c29c8fb31a01bf7c84d53188897afeaefdd6dc8d6d14490d15f6f9ea37af4" => :el_capitan
    sha256 "4009fdf987166c815428738a1fd2e6d784846899a9d36685f3380f19f00b6b8f" => :yosemite
    sha256 "51f05828adedb594550f42ee1f4c3e3352aa9c110249786ed0c69acce247e2ad" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.14.2/crystal-0.14.2-1-darwin-x86_64.tar.gz"
    version "0.14.2"
    sha256 "f75036b1950035b49a73faa125acd9ff031cecab7020f15cd4db4c4ee6417bfa"
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
