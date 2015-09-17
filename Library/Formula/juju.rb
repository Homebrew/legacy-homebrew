class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.6/+download/juju-core_1.24.6.tar.gz"
  sha256 "00928687041e3520146d7d937a51d1e7caf9b588bb9c80f02846addebe452cbd"

  bottle do
    cellar :any_skip_relocation
    sha256 "e69b88bb8dce93389f2b5be826010580bcb9d8aaca312c256a3d94d2c0ca41c9" => :el_capitan
    sha256 "0edfb2f7cbf65f9e71e96831280ef2c748a0c2aa1424b9131c0f9ca9b3b54c89" => :yosemite
    sha256 "1c93c724ad0f68a11fc45db936a8130a56a9646a9c2f979accbb6641356fc762" => :mavericks
    sha256 "ff279800b3e7f5014e66cbe63ab00ac5fe7ae8b81c177e8fc58c54bb9db674c1" => :mountain_lion
  end

  depends_on "go" => :build

  # El Capitan is not registered in Juju 1.24.x.
  # https://bugs.launchpad.net/juju-core/+bug/1465317
  # https://github.com/juju/juju/pull/3388
  patch do
    url "https://gist.githubusercontent.com/sinzui/68da12cb48493d41bdbc/raw/29f30ce225be0c4599ef2834f1585c939a507348/el-capitan.patch"
    sha256 "326764b4c6da32823aa70b4a5f03a1d196983de4714a8d259e44e7a7a1ac53fe"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
