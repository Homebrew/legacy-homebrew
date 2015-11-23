class Tutum < Formula
  desc "Docker platform for dev and ops"
  homepage "https://www.tutum.co/"
  url "https://github.com/tutumcloud/cli/archive/v0.20.0.tar.gz"
  sha256 "313e6c2adced5895df778939e0bd1d2198582646e0c264ba01b0e29dfd635e4a"

  bottle do
    cellar :any
    sha256 "f598d0b7096cf8b37b25415b7255289008a72809275422a0698f8bac3f82e9a4" => :el_capitan
    sha256 "f5d353c31804d77c211687430d1a24c7cb802f10f74abcab65bb09bb39377045" => :yosemite
    sha256 "084df6a94c8dda5f14036b7dd63cc4b18f56968fa4c4ca7fc6ccbb1f1aff3092" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "ago" do
    url "https://pypi.python.org/packages/source/a/ago/ago-0.0.6.tar.gz"
    sha256 "a64811a5a44cd3ba687d800986edf0f7a97859b8da75d3347c915b58b0869b44"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.2.3.tar.gz"
    sha256 "5328a7f4a2d812da166b3fb59211fca976c9f48bb9f8b17d9f3fd4ef7c765ac5"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha256 "e713da45c96ca53a3a8b48140d4120374db622df16ab71759c9ceb5b8d46fe7c"
  end

  resource "python-tutum" do
    url "https://github.com/tutumcloud/python-tutum/archive/v0.20.0.tar.gz"
    sha256 "45cb8165e47d2e6521d8424fa57e3869a3a835990ad03bc3d2b330c7e14c1dad"
  end

  resource "backports.ssl-match-hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.2.tar.gz"
    sha256 "532ccab8d9e4659a5f016d84814df86cc04763785e9de2739e890d956dc82d8f"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket_client-0.32.0.tar.gz"
    sha256 "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040"
  end

  resource "future" do
    url "https://pypi.python.org/packages/source/f/future/future-0.14.3.tar.gz"
    sha256 "62857d51881d97dd5492b9295b9f51d92108a52a4c88e2c40054c1d3e5995be9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/tutum", "container"
  end
end
