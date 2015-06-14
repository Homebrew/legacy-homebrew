class Curlish < Formula
  desc "A curl wrapper that adds support for OAuth 2.0"
  homepage "https://pythonhosted.org/curlish/"
  url "https://github.com/fireteam/curlish/archive/1.22.tar.gz"
  sha256 "6fdd406e6614b03b16be15b7b51568a7a041d2fb631be4e8caa223c0c3a28f00"

  head "https://github.com/fireteam/curlish.git"

  # curlish needs argparse (2.7+)
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "curlish.py" => "curlish"
  end

  test do
    system "#{bin}/curlish", "http://brew.sh"
  end
end
