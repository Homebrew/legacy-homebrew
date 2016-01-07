class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/OiNutter/node-build"
  url "https://github.com/OiNutter/node-build/archive/v2.1.0.tar.gz"
  sha256 "bb7a12abbbdaad225265bf32b8ac934f0195ff035a4f12461ef2546f24a51b20"
  head "https://github.com/OiNutter/node-build.git"

  bottle :unneeded

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
