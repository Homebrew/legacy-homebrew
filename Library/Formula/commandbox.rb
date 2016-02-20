class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "http://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-bin-3.0.0.zip"
  sha256 "194738f683cbbbaa63f7a2ae5d1fe6c0d09ef8370c4ac0b6c9aa087f6013abc1"
  devel do
    url "http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/commandbox-bin-3.1.0.zip"
    sha256 "0ba0bb96114a73961ee4a8e3a656c72b98cd2f3cd561b92d159bebcfef240418"
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

  def caveats; <<-EOS.undent
    CommandBox is licensed as open source software under the GNU Lesser General Public License v3

    License information at:
    http://www.gnu.org/licenses/lgpl-3.0.en.html

    For full CommandBox documentation visit:
    https://ortus.gitbooks.io/commandbox-documentation/

    Source Code:
    https://github.com/Ortus-Solutions/commandbox
    EOS
  end

  test do
    # This test is currently failing in the sandbox, but runs on the CLI with --no-sandbox
    # The errors are coming from an incorrect context root by the Lucee servlet
    # Will need to investigate a way to set this ENV variable upstream for the sandbox
    system "box", "--commandbox_home=~/", "version"
    system "box", "--commandbox_home=~/", "help"
  end
end
