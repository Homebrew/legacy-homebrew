class Watson < Formula
  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  url "https://pypi.python.org/packages/source/t/td-watson/td-watson-1.3.2.tar.gz"
  sha256 "f92f3b33595f3e31bb0417b6443541f036bd7dabea19daf471fe5c3ac75b9c8d"

  head "https://github.com/TailorDev/Watson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b28bfbdc75e530760733360be2c40f0a02c2ef6a3c31f5665779903786a1e92e" => :el_capitan
    sha256 "edb07d1e281f0a359c12c12a74402640499402037c7acc82da9c29d4781af605" => :yosemite
    sha256 "5e57982340da15e3e58642c7be8f3f9d3b9239f8433bf8bf680a968efc050cd8" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "arrow" do
    url "https://pypi.python.org/packages/source/a/arrow/arrow-0.7.0.tar.gz"
    sha256 "2a5333007af117a05a488b69c9ae15c26c23eefa25f084992b025d387e03a17b"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.2.tar.gz"
    sha256 "fba0ff70f5ebb4cebbf64c40a8fbc222fb7cf825237241e548354dabe3da6a82"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
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
    system "#{bin}/watson", "start", "foo", "+bar"
    system "#{bin}/watson", "status"
    system "#{bin}/watson", "stop"
    system "#{bin}/watson", "log"
  end
end
