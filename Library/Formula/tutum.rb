require "formula"

class Tutum < Formula
  homepage "https://www.tutum.co/"
  url "https://github.com/tutumcloud/tutum-cli/archive/v0.13.1.tar.gz"
  sha1 "15bf12efd98fdb9d4efdbd93ae8d05761e37f258"

  bottle do
    cellar :any
    sha256 "b0d1389b2039692cf6616c76bc499900a91b3d7eb2b949119d02cf75dd0d598c" => :yosemite
    sha256 "29a636a76c5aa04873075c8ab8deabecc72c9f9d574057b1a9cd9dfee93ec676" => :mavericks
    sha256 "93678d20fd3530e0571aaad1ce53ab3eeafd60757e65929fb8cb623e05a6a737" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "ago" do
    url "https://pypi.python.org/packages/source/a/ago/ago-0.0.6.tar.gz"
    sha1 "b48b99151370de0c1642748a3f3b206649645d8d"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.1.0.tar.gz"
    sha1 "989eaf213f38c694798a326f21a66d982edee16c"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha1 "476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73"
  end

  resource "python-tutum" do
    url "https://pypi.python.org/packages/source/p/python-tutum/python-tutum-0.12.6.tar.gz"
    sha1 "21374ce80c82a7e99f1f7a5fd63d1772df541651"
  end

  resource "backports.ssl-match-hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha1 "da4e41f3b110279d2382df47ac1e4f10c63cf954"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.2.tar.gz"
    sha1 "fbafcd19ea0082b3ecb17695b4cb46070181699f"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.2.tar.gz"
    sha1 "da057c6d4faab9847436c3221c98f34911e623df"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket_client-0.26.0.tar.gz"
    sha1 "14f7668f579ab94e1fc7a26ef182add964192b34"
  end

  resource "future" do
    url "https://pypi.python.org/packages/source/f/future/future-0.14.3.tar.gz"
    sha1 "44fdd9323913d21068b29ecda795a98c07dc8a40"
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
