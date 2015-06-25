require "formula"

class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.4.0.tar.gz"
  sha1 "142859ba1eb9385fa78d936ad4efd62584bd618b"
  head "https://github.com/defunkt/gist.git"

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/gist", "--version"
  end
end
