class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.9.0.tar.gz"
  sha256 "b125e58ab88ca7a6cb654c40143b6e9f8c4fb284cbe5e4da20ae372ed9b31ba0"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "b78a1225065fafe0293ab59643364db3958595971019cb2d1509f07a01894e3a" => :el_capitan
    sha256 "34fc0370c9ed35772f8f6443d62ac408b9bae89b87156a1dc4018bd9051c47fc" => :yosemite
    sha256 "9b4f849cedd7375ea92f99f2a1b6df548cd44147826dc35838ddab5b5fb00deb" => :mavericks
  end

  resource "boot" do
    url "https://github.com/manastech/crystal/releases/download/0.8.0/crystal-0.8.0-1-darwin-x86_64.tar.gz"
    sha256 "5a16826145a846da3548e875cf104bdfc04c35cd6628cf66487de1bfbe9c5faf"
  end

  resource "shards" do
    url "https://github.com/manastech/shards/archive/v0.5.1-crystal.0.9.0.tar.gz"
    sha256 "5dd06933a24064b40a2056015184da77273be6903690ccc4702d77ad898d7d27"
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
