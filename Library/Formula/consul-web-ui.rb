class ConsulWebUi < Formula
  desc "Provides the consul web ui"
  homepage "https://www.consul.io/intro/getting-started/ui.html"
  url "https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip"
  version "0.5.2"
  sha256 "ad883aa52e1c0136ab1492bbcedad1210235f26d59719fb6de3ef6464f1ff3b1"

  depends_on "consul" => :optional
  def install
    # copying the unzipped dist folder to prefix
    prefix.install "../dist"
    # create a symlink in opt
    opt_prefix.install_symlink prefix
  end
  test do
    assert_equal true, File.exist?("#{opt_prefix}/dist/index.html")
  end
end
