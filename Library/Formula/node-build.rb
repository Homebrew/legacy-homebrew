class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/OiNutter/node-build"
  url "https://github.com/OiNutter/node-build/archive/v2.1.2.tar.gz"
  sha256 "640a7a452f7dd613a6382a673925142404373fd2dca13e841930156cd6d962da"
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
