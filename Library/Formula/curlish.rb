class Curlish < Formula
  desc "A curl wrapper that adds support for OAuth 2.0"
  homepage "https://pythonhosted.org/curlish/"
  url "https://github.com/fireteam/curlish/archive/1.22.tar.gz"
  sha1 "45e9a7d92b5f70adf257cda3f9f0f205eef0245b"

  # curlish needs argparse (2.7+)
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "curlish.py" => "curlish"
  end

  test do
    system "#{bin}/curlish", "http://brew.sh"
  end
end
