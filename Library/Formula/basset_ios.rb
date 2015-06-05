class BassetIos < Formula
  desc "Converting vector images to PNG(s) and organizes them in xcassets"
  homepage "https://github.com/Polidea/basset-ios"
  url "https://github.com/Polidea/basset-ios/archive/1.0.tar.gz"
  sha256 "66cfa8d19dfbca7c6211c2400207970244c7867c16263622d3f1a94cd9dae0c6"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "imagemagick"
  depends_on "ghostscript"

  resource "coloredlogs" do
    url "https://pypi.python.org/packages/source/c/coloredlogs/coloredlogs-1.0.tar.gz"
    sha256 "35e1e8a422b27d8c8e66eaa30d5dfff80d9c233bd52543e10b79688781b0510b"
  end

  resource "Wand" do
    url "https://pypi.python.org/packages/source/W/Wand/Wand-0.4.0.tar.gz"
    sha256 "3ef8cbadb122808c123b33d34a9cc833a91eebb700ebea1d5d610fa807f55a89"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "humanfriendly" do
    url "https://pypi.python.org/packages/source/h/humanfriendly/humanfriendly-1.26.tar.gz"
    sha256 "0908b90298364e3335a03abcbb88ec571f95c7e4bc6728de0551806f636ef219"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec

    libexec.install "basset"
    bin.install "basset_ios"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/basset_ios", "-h"
  end
end
