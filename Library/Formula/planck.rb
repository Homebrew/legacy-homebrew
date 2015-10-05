class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  head "https://github.com/mfikes/planck.git"
  url "https://github.com/mfikes/planck/archive/1.7.tar.gz"
  sha256 "11f5017519c3a10267465c73ef9da7c1f3c228cebed056b0ce7a8335e141aefc"

  bottle do
    cellar :any_skip_relocation
    sha256 "aded391f9335078e65849e09f052fa4d3684913f7b1d16813d4a663ea6572bef" => :el_capitan
    sha256 "2d4781eff1bbd87bf1f5c2f636fdb14eba573f16fb22f8bc81a9a2d4bc7f8505" => :yosemite
    sha256 "26a41703f91e22d7dd4954e4011f3da493dec0bb821c67fcb227df48da105753" => :mavericks
  end

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :lion

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
