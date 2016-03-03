class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.10.tar.gz"
  sha256 "4ed7d3aa38d5775002819588cb5a4f0b54aa866587072f07505626d51d7a1b91"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25251f8762f2d66e39551c6f3775bfb9ed48ee9fb23fb9a3b81c9e61039a3a62" => :el_capitan
    sha256 "05a1e4834ecffa3f2428e5930eaca679dbcebd62adb56d71604a786191c2b4d8" => :yosemite
    sha256 "ed75d94350e555ded5f90132d15430dd85aaf145d65b4d2b0765af85a6c67077" => :mavericks
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
