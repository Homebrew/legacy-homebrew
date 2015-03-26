class Dub < Formula
  homepage "http://code.dlang.org/about"
  url  "https://github.com/D-Programming-Language/dub/archive/v0.9.22.tar.gz"
  sha1 "9a7b7c838f1241de209473c09a194d355279457b"

  head "https://github.com/D-Programming-Language/dub.git", :shallow => false

  devel do
    url "https://github.com/D-Programming-Language/dub/archive/v0.9.23-rc.1.tar.gz"
    sha1 "3fe35139a58d9ceaee1e920940dc5e67f2b1f178"
    version "0.9.23-rc.1"
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
