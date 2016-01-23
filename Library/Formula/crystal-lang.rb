class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.11.0.tar.gz"
  sha256 "2aab021f344c28a7f2bb51fb33d273f8c9c95b6adfdae6f578405f891e10236b"
  head "https://github.com/manastech/crystal.git"

  bottle do
    sha256 "2269242f2efbfce2253ec497d7c7eb1c5f760265f0c19309f71ac44475cf5975" => :el_capitan
    sha256 "2b61a0ac887b37960a23bfea475f2431a0f29149e0108a1a2de5d3dede26da83" => :yosemite
    sha256 "9d9c7ff18540010779527d8bbebcdb82cd3c5ff7a8c5a9f22cfc16a21f978a1e" => :mavericks
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
  end

  test do
    system "#{bin}/crystal", "eval", "puts 1"
  end
end
