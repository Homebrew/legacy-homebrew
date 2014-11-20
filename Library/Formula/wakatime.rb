require "formula"

class Wakatime < Formula
  homepage "https://wakatime.com/"
  url "https://pypi.python.org/packages/source/w/wakatime/wakatime-2.1.6.tar.gz"
  sha1 "e288befaeefaaeec303efa36f2b7488829a6cf0d"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"

    Language::Python.setup_install "python", libexec

    bin.install Dir[libexec/"bin/*"]
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
