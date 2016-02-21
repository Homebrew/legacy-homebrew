class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "http://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-bin-3.0.0.zip"
  sha256 "194738f683cbbbaa63f7a2ae5d1fe6c0d09ef8370c4ac0b6c9aa087f6013abc1"

  bottle :unneeded

  devel do
    url "http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/commandbox-bin-3.1.0.zip"
    sha256 "b2b9b74f7bd1f3b547d72e08e4b59c8c8163e6ba4504b2f46e8cf10884918351"
  end

  depends_on :java => "1.7+"

  resource "apidocs" do
    url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-apidocs-3.0.0.zip"
    sha256 "0da5f3b3d00784ffef1dc00d9b2d54a0f602a4947a59038521f87d09df0233f8"
  end

  def install
    bin.install "box"
    doc.install resource("apidocs")
  end

  test do
    system "box", "--commandbox_home=~/", "version"
    system "box", "--commandbox_home=~/", "help"
  end
end
