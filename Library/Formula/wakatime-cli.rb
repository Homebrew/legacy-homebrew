require "formula"

class WakatimeCli < Formula
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/source/w/wakatime/wakatime-2.1.6.tar.gz"
  sha1 "e288befaeefaaeec303efa36f2b7488829a6cf0d"

  bottle do
    cellar :any
    sha1 "f86da63f44a8f37549793e0a96ab45e754e9ad10" => :yosemite
    sha1 "670bf3c24ca821a2ac4cf28005b23c39848378f9" => :mavericks
    sha1 "e427096705397e307be29b0adc32ed471b88d548" => :mountain_lion
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
