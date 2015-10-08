class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.8.0.tar.gz"
  sha256 "986a000bb2eded22e446fd55c543062770ec4000e28791f0b07f63fcee37b245"
  head "https://github.com/manastech/crystal.git"

  resource "boot" do
    url "https://github.com/manastech/crystal/releases/download/0.8.0/crystal-0.8.0-1-darwin-x86_64.tar.gz"
    sha256 "5a16826145a846da3548e875cf104bdfc04c35cd6628cf66487de1bfbe9c5faf"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.5.1.tar.gz"
    sha256 "95916792766e42e3b005b144190c3f88d5cb8bcbaaddeb8fa8ced8bac1ef424d"
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
