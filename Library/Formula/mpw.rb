class Mpw < Formula
  desc "Master Password for the terminal"
  homepage "http://masterpasswordapp.com"
  url "https://ssl.masterpasswordapp.com/mpw-2.1-cli4-0-gf6b2287.tar.gz"
  sha1 "036b3d8f4bd6f0676ae16e7e9c3de65f6030874f"
  version "2.1-cli4"

  bottle do
    cellar :any
    sha1 "67cc0d3615113021c944212cb3a8c5d07d404a58" => :yosemite
    sha1 "9a41c1d203ec3fbb31e8e4c6daceba7c7f7ceb91" => :mavericks
    sha1 "05f7d8d6eac5b6195e33c4ba9d928897b26b561a" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "openssl"

  resource "libscrypt" do
    url "http://masterpasswordapp.com/libscrypt-b12b554.tar.gz"
    sha1 "ee871e0f93a786c4e3622561f34565337cfdb815"
  end

  def install
    resource("libscrypt").stage buildpath/"lib/scrypt"
    touch "lib/scrypt/.unpacked"

    ENV["targets"] = "mpw mpw-tests"
    system "./build"
    system "./mpw-tests"

    bin.install "mpw"
  end

  test do
    assert_equal "RoliQeka7/Deqi",
      shell_output("mpw -u user -P password test.com 2>/dev/null").strip
  end
end
