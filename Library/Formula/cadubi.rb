class Cadubi < Formula
  desc "Creative ASCII drawing utility"
  homepage "https://github.com/statico/cadubi"
  url "https://github.com/statico/cadubi/archive/v1.3.1.tar.gz"
  sha256 "162c3ba748bbd2ab1699c95d4ad0e257ffe183959e6ce084ab91efbd3eb73f8a"

  head "https://github.com/statico/cadubi.git"

  bottle :unneeded

  def install
    inreplace "cadubi", "$Bin/help.txt", "#{doc}/help.txt"
    bin.install "cadubi"
    doc.install "help.txt"
    man1.install "cadubi.1"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s,
      shell_output("script -q /dev/null #{bin}/cadubi --version 2>&1", 1)
  end
end
