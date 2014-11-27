require "formula"

class Tutum < Formula
  homepage "https://www.tutum.co/"
  url "https://github.com/tutumcloud/tutum-cli/archive/v0.10.5.tar.gz"
  sha1 "82238e8eba3a69879a523dd348baf9d47d00eba5"

  bottle do
    cellar :any
    sha1 "3c1e3375479104505398e93977a85a8102651fe0" => :yosemite
    sha1 "1755746e4e6c3281ad7a7c0147434c3f806236de" => :mavericks
    sha1 "c390a4c6dc4915d256db7e340327ade39fcbe798" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha1 "476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.4.3.tar.gz"
    sha1 "411f1bfa44556f7dd0f34cd822047c31baa7d741"
  end

  resource "ago" do
    url "https://pypi.python.org/packages/source/a/ago/ago-0.0.6.tar.gz"
    sha1 "b48b99151370de0c1642748a3f3b206649645d8d"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-0.5.3.tar.gz"
    sha1 "11708a7021e3d0d522e145c057256d7d2acaec07"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.2.tar.gz"
    sha1 "fbafcd19ea0082b3ecb17695b4cb46070181699f"
  end

  resource "python-tutum" do
    url "https://pypi.python.org/packages/source/p/python-tutum/python-tutum-0.10.5.tar.gz"
    sha1 "4e14fd392f69e0efd91f05f7a9dfc257677eb04f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.2.tar.gz"
    sha1 "da057c6d4faab9847436c3221c98f34911e623df"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm "#{lib}/python2.7/site-packages/site.py"
    rm "#{lib}/python2.7/site-packages/easy-install.pth"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/tutum", "container"
  end
end
