class Browser < Formula
  desc "Pipe HTML to a browser"
  homepage "https://gist.github.com/318247/"
  url "https://gist.github.com/defunkt/318247/raw/7720fc969d58a9bfdc74d71deaa15c1eb7582fc1/browser",
    :using => :nounzip
  # This the gist revision number
  version "7"
  sha256 "273343d6cf9ed543ccea47b85a2ad2ef2afe7b7a2b956f2e7a24ce0175326dcc"

  bottle :unneeded

  def install
    bin.install "browser"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/browser"
  end
end
