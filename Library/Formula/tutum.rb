require "formula"

class Tutum < Formula
  homepage "https://www.tutum.co/"
  url "https://github.com/tutumcloud/tutum-cli/archive/v0.12.6.1.tar.gz"
  sha1 "75d44ba0fb7f360dfa1931ce5cf0134cc69985e0"
  revision 1

  bottle do
    cellar :any
    sha256 "eb1cd49f6dd12f483bdff9e189562b0ef9bd9873aa1f28a29f0015587ce22a13" => :yosemite
    sha256 "29d3d5523a6a15916ebb95d194a6cbf01c0d6320b6af874d00e7b90332b2062d" => :mavericks
    sha256 "8f268a0df07425aa566cc97b12f9e126aa9d2ceaae0caa0158271a5e7a3b5653" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "ago" do
    url "https://pypi.python.org/packages/source/a/ago/ago-0.0.6.tar.gz"
    sha1 "b48b99151370de0c1642748a3f3b206649645d8d"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-0.5.3.tar.gz"
    sha1 "11708a7021e3d0d522e145c057256d7d2acaec07"
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
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.23.0.tar.gz"
    sha1 "3348c226eb44324417db777e962fec6bda8134b9"
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
