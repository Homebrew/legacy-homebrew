class Platformio < Formula
  desc "Ecosystem for IoT development (Arduino and MBED compatible)"
  homepage "http://platformio.org"
  url "https://pypi.python.org/packages/source/p/platformio/platformio-2.8.4.tar.gz"
  sha256 "5728bee3281a10e33f4727da0cdb3f7b1f333fd415fdbbde6ad1591a963344b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "22c330f0f80e3001a3fe88f15905b606643573eeec8efbc744e54df1974c055d" => :el_capitan
    sha256 "8b1306bc427549282fb2e5724c441fa10f80939955d7f588e0aeea416c89f437" => :yosemite
    sha256 "64f1a6de79b434f20d1f0323c67a1836e39edc4a0ae15b00d22272242d5b404c" => :mavericks
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
