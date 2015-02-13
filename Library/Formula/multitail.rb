class Multitail < Formula
  homepage "http://vanheusden.com/multitail/"
  url "http://www.vanheusden.com/multitail/multitail-6.4.1.tgz"
  sha1 "9191b807f8d727810b2824a9bc8aafa17cb0d10e"

  # Upstream pull request to fix compilation issues on OS X
  # https://github.com/flok99/multitail/pull/13
  patch do
    url "https://github.com/flok99/multitail/pull/13.diff"
    sha1 "cf1c457ecfc2fbe76f60050829af30c8a6698d5c"
  end

  def install
    system "make", "-f", "makefile.macosx", "multitail"

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
