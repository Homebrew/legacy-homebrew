class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/OiNutter/node-build"
  url "https://github.com/OiNutter/node-build/archive/v2.0.1.tar.gz"
  sha256 "21d62820fb918cb4866d315f9f0c157b655d994857949f179a58756c6dde7d14"
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
