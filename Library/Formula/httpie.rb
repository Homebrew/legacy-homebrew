require "formula"

class Httpie < Formula
  homepage "http://httpie.org"
  url "https://github.com/jakubroztocil/httpie/archive/0.8.0.tar.gz"
  sha1 "bfffe9d782a896ca57f3dafef3d02bf81a07e5a8"

  head "https://github.com/jakubroztocil/httpie.git"

  depends_on :python

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
  end

  def install
    resource("pygments").stage { system "python", "setup.py", "install", "--prefix=#{libexec}", "--single-version-externally-managed", "--record=installed.txt" }
    system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "#{bin}/http", "https://google.com"
  end
end
