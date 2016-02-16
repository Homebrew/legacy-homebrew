class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "http://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-bin-3.0.0.zip"
  sha1 "cb8d454b99d56c16e8501b4e1aa3c4eeb9b44451"
  devel do
    url "http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/commandbox-bin-3.1.0.zip"
    sha1 "2e3bab8443b7965931cd7c2f4edefc14c6e4297c"
  end

  depends_on :arch => :x86_64
  depends_on :java => "1.7+"

  resource "apidocs" do
    url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-apidocs-3.0.0.zip"
    sha1 "2ffe33c1d3ec02c56a9879c99ffe5b7fc792959a"
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
    system "box", "install"
    system "box", "--version"
  end
end
