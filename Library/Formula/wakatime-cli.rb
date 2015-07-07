require "formula"

class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/source/w/wakatime/wakatime-4.0.14.tar.gz"
  sha1 "8bf0ca4b9c3309558ca8941bd547fcc8931b725c"

  bottle do
    cellar :any
    sha256 "e5810fb8f787cd9be980b44651d58076d9199e968b73d90cc6a618915061d5f5" => :yosemite
    sha256 "4538612e2175e482cd4ce7ee44814ba0847c8527f99b5b5385c1924353998b3d" => :mavericks
    sha256 "ddefa41fd45e9535fa7c972b22d7e264f702bf0a50f8ec93b0270199b87ea83c" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = libexec+"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
