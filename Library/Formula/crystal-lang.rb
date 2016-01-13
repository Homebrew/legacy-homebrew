class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.10.2.tar.gz"
  sha256 "05e1af0c50438c33f2912598eac684a12b1c7193e16a19f9870de50552cede5b"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "70711d694b0906c1d67a82f44357c70b568a16a3f1860e14c7fe643b197a76e8" => :el_capitan
    sha256 "be67aa7cfea8d5531541c7c1baf9293fcf26a54e3a41a0be262f8636470f40c0" => :yosemite
    sha256 "181a4a048d438a1cd1d3dc7e9f4bb729be5499d92d9f80d35e8daa6c677fe7c6" => :mavericks
  end

  resource "boot" do
    url "https://github.com/manastech/crystal/releases/download/0.10.0/crystal-0.10.0-1-darwin-x86_64.tar.gz"
    sha256 "a94562c2e683a6149accb6ec52f30e96ff2cd5a4cdbf3d0785181c9ec561f003"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.5.4.tar.gz"
    sha256 "759a925347fa69a9fbd070e0ba7d9be2d5fe409a9bc9a6d1d29090f2045e63c1"
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "libpcl"
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
  end

  test do
    system "#{bin}/crystal", "eval", "puts 1"
  end
end
