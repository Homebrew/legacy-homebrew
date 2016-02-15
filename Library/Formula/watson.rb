class Watson < Formula
  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  url "https://github.com/TailorDev/Watson/archive/1.3.1.tar.gz"
  sha256 "de7190f8cb304004b096be1b5992eb826306da75cbaa04fd588ab113c08e0250"

  head "https://github.com/TailorDev/Watson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e339ad5addbd5db13e77aafb488a548de1f0ce59bd4a8b3e4ab8b9563ee2c88" => :el_capitan
    sha256 "6d322b05eeb5d37129e8ffe5b91747a3de1d7300bd69dd1a21ca2744f5fdd521" => :yosemite
    sha256 "6ade33b986db02b3f33f459b68ab0fd59b1536510a4ccb269fb8e3a6ff02b119" => :mavericks
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

  resource "pytest-runner" do
    url "https://pypi.python.org/packages/source/p/pytest-runner/pytest-runner-2.6.2.tar.gz"
    sha256 "e775a40ee4a3a1d45018b199c44cc20bbe7f3df2dc8882f61465bb4141c78cdb"
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
