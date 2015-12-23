class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.10.0.tar.gz"
  sha256 "349172eacaf1cd1a2e984b2ecd02aa5c7e64c318f27afe58004bf955aa332922"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "bda84aafa263a59ab7288ed1438a90202e7e30e7e50f97d90d35b78e45689cf1" => :el_capitan
    sha256 "4273cdbffa3ca35891c196a2a618ddecba56638e9cde96312789d3454384aee0" => :yosemite
    sha256 "6f5c16d445212da957f466be10b5d99bd9e8a5b5164c82e090e61d73d66ca15b" => :mavericks
  end

  resource "boot" do
    url "https://github.com/manastech/crystal/releases/download/0.9.1/crystal-0.9.1-1-darwin-x86_64.tar.gz"
    sha256 "1103edbb5d1ccb9555ce81d2b3630e7fbde93a75b2e368433859de0e4dc2717e"
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
