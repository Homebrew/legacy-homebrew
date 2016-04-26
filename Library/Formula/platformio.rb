class Platformio < Formula
  desc "Ecosystem for IoT development (Arduino and MBED compatible)"
  homepage "http://platformio.org"
  url "https://pypi.python.org/packages/source/p/platformio/platformio-2.8.6.tar.gz"
  sha256 "34b683055127b7cd132baf0e784c96df22aa90afc2d3ad5947bd52871c6712d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a424dd4ed6cab22405c38c19aa1abf2f58e43ace6da6f379606965489a06166a" => :el_capitan
    sha256 "9077194af92cbd44a1abd1ec2117286549fb5a8aad441684bfe4351162239b0c" => :yosemite
    sha256 "7d9de6261aa70184524957bdd896323f633c7c719be655beea4ae844593040ef" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "bottle" do
    url "https://pypi.python.org/packages/source/b/bottle/bottle-0.12.9.tar.gz"
    sha256 "fe0a24b59385596d02df7ae7845fe7d7135eea73799d03348aeb9f3771500051"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.6.tar.gz"
    sha256 "ec9efcccb086a1d727876384f94ee6358d2f3f096688c1ba18b0f318f2b453b5"
  end

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/source/p/pyserial/pyserial-3.0.1.tar.gz"
    sha256 "969cb6405d1d87f8960cf9c10f597ae58f85da2fb9769dba96f4aeeaade54656"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
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
    system bin/"platformio"
    system bin/"pio"
  end
end
