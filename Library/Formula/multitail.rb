class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "http://vanheusden.com/multitail/"
  url "http://www.vanheusden.com/multitail/multitail-6.4.1.tgz"
  sha1 "9191b807f8d727810b2824a9bc8aafa17cb0d10e"

  bottle do
    cellar :any
    sha1 "a6911971f13cac78f86e31643c7eb5746092c553" => :yosemite
    sha1 "69576c39aab13d2ce6451db33dbcf46b68e20596" => :mavericks
    sha1 "81473772c2a8b55e79299c17d1a595496da7c1ff" => :mountain_lion
  end

  # Upstream pull request to fix compilation issues on OS X
  # https://github.com/flok99/multitail/pull/13
  patch do
    url "https://github.com/flok99/multitail/pull/13.diff"
    sha1 "cf1c457ecfc2fbe76f60050829af30c8a6698d5c"
  end

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match "multitail #{version}",
      shell_output("#{bin}/multitail -h 2>&1", 1)
  end
end
