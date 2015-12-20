class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.7.2.tar.gz"
  sha256 "b26e637f02bf37edbbe3c5e6ccdb058cb6e0ceca8ead0c8878cf20764803421c"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1554c4302457a34ee3731d9f0a3543a3f8132033b5116227d7744eb07638dbd7" => :el_capitan
    sha256 "833442db5e6a85c0fb09b0da6e48a824f78e8f3ed19c3ecda9329ddb0f50b6af" => :yosemite
    sha256 "f9589b35d50dd85879b37055edc374e5358f9981b646ad8c95dcb7b4c0dfdd3f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "openssl"

  def install
    ENV["USE_SYSTEM_SSL"] = "1"
    ENV["USE_SYSTEM_LUAJIT"] = "1"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    system bin/"luvit", "--cflags", "--libs"
  end
end
