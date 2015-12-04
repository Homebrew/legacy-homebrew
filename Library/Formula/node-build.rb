class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/OiNutter/node-build"
  url "https://github.com/OiNutter/node-build/archive/v2.0.2.tar.gz"
  sha256 "b48137946700320933014f4435f61c6b6375d0aa9c4f55faeb29a9e0e1ad934c"
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
