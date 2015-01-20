require "formula"

class Mpw < Formula
  homepage "http://masterpasswordapp.com"
  url "https://ssl.masterpasswordapp.com/mpw-2.1-cli3-3-gd5ff215.tar.gz"
  sha1 "c9fca230cd0c2b22082bc54fe85053219888212a"

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

    ENV["targets"]="mpw mpw-tests"
    system "./build"
    system "./mpw-tests"

    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
        shell_output("mpw -u 'Robert Lee Mitchell' -P 'banana colored duckling' masterpasswordapp.com").strip
  end
end
