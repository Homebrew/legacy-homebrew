class Browser < Formula
  url "https://gist.github.com/defunkt/318247/raw/7720fc969d58a9bfdc74d71deaa15c1eb7582fc1/browser",
    :using => :nounzip
  desc "Pipe HTML to a browser"
  homepage "https://gist.github.com/318247/"
  sha1 "beaf6c40851628d188eccc9cc013d44dcb037521"
  # This the gist revision number
  version "7"

  def install
    bin.install "browser"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/browser"
  end
end
