require "formula"

class Tutum < Formula
  homepage "https://www.tutum.co/"
  url "https://github.com/tutumcloud/tutum-cli/archive/v0.13.0.tar.gz"
  sha1 "e03f15d73286e113c1d376fa7860e4c0ba6d8911"

  bottle do
    cellar :any
    sha256 "c7e95ba2487cd1ad0170d8f5e62a209218c6d316933728a2863e44acbbdcaf7a" => :yosemite
    sha256 "6848097e5b784ccd885c9a003e485971c056b3e66ccf9b1b06b3eafb69787d00" => :mavericks
    sha256 "d525cdef3c942ec50fb0d0bb26569e0bc163c1b8e2c23c591c2cff5b7a75a62d" => :mountain_lion
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
