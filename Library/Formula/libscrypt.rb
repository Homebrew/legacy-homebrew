require "formula"

class Libscrypt < Formula
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.19.tar.gz"
  sha1 "fb457aab4561a929dda2872da52b02710c07b7a5"

  bottle do
    cellar :any
    sha1 "471622a1f4fe31bc2b54e93bb7ae1253edbbc2da" => :mavericks
    sha1 "60f5c75dbb4b14ed4f3c7bc89a9410b78f791c90" => :mountain_lion
    sha1 "8fef4e66f57d7faf2a23ecf1c3f3fcbeb58d6217" => :lion
  end

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end
end
