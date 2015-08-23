class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.8.18026.tar.gz"
  sha256 "ff75b2b0a4df30aef4f6cd2ba20fb3fa1198760fb7d8216abc62e032df4aa1e4"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "b14924b6c4dac4b231f66cc7884bddf038d37f40be590c8862971c861b625375" => :yosemite
    sha256 "64101f8ba099696c0fce07e14fe7986ffe7d31a91c58bae50abe402af490b1a1" => :mavericks
    sha256 "84feb0fe67c6efc85b4afb7ad029989623046f4b5dab717098af371900d0b887" => :mountain_lion
  end

  depends_on :java => ["1.7+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "ant", "-Dbuild.compile.target=1.7", "-Drevision=#{revision}", "cli"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["when"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["when"].stable.checksum
  end
end
