class DockerCloud < Formula
  desc "SaaS to build, deploy and manage Docker-based applications"
  homepage "https://cloud.docker.com/"
  url "https://pypi.python.org/packages/source/d/docker-cloud/docker-cloud-1.0.1.tar.gz"
  sha256 "e86246002168e1e1a8e91e8a816d7091042d362fdf8f72a9358da0ce4e7da02c"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "ago" do
    url "https://pypi.python.org/packages/source/a/ago/ago-0.0.6.tar.gz"
    sha256 "a64811a5a44cd3ba687d800986edf0f7a97859b8da75d3347c915b58b0869b44"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha256 "e713da45c96ca53a3a8b48140d4120374db622df16ab71759c9ceb5b8d46fe7c"
  end

  resource "python-dockercloud" do
    url "https://pypi.python.org/packages/source/p/python-dockercloud/python-dockercloud-1.0.1.tar.gz"
    sha256 "68f1fab2d7de15b4f7a9c8f55c1adb7c76b654d86a44f6025cf3de85991a33d5"
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
    url "https://pypi.python.org/packages/source/f/future/future-0.15.0.tar.gz"
    sha256 "7f8ad46e287ac32e3dae78be41098c83d690b364142e0a5f11958c2b549420b0"
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
    system "#{bin}/docker-cloud", "container"
  end
end
