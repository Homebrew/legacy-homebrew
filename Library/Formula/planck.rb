class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.10.tar.gz"
  sha256 "4ed7d3aa38d5775002819588cb5a4f0b54aa866587072f07505626d51d7a1b91"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3621f8a980bcc9cc34ed0567418dbdf53d2a64af42337f873fa796440f7dca6" => :el_capitan
    sha256 "0e928b9a6313949a5f2f44e83624a1eab0fe83907159147bf4e1d6344bbd683f" => :yosemite
    sha256 "8c97a1b4cb5b9dc5027daa1f0f296669b068db1314e2d655f4f53d957a0e8b8e" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on "maven" => :build
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
