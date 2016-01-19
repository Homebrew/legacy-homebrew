class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.7.2.tar.gz"
  sha256 "b26e637f02bf37edbbe3c5e6ccdb058cb6e0ceca8ead0c8878cf20764803421c"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2955d510e4014b8ce9d95ba67649ea2d355eba4d1cf1ef06430806d6b69bf03" => :el_capitan
    sha256 "f3e4cc67fd94b97cbc4bc7f73fad4ceb5567f7b36367b4596196beb63eade8c4" => :yosemite
    sha256 "b4026e5ef8fb466e6e266ead2967902b90fbdad5930259df9867a3bf6f48ec38" => :mavericks
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
