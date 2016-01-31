class Scour < Formula
  desc "SVG file scrubber"
  homepage "http://www.codedread.com/scour/"
  url "https://github.com/codedread/scour/archive/v0.33.tar.gz"
  sha256 "e9b4fb4beb653afbdbc43c4cc0836902d6f287d882b6b7cdf714c456ff0841a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef832fb97ec1fc85ebaa890ae340e4c94c57bb6a6b75a3bf783e7514288b413c" => :el_capitan
    sha256 "cda2fae4288fbdb52aee2aa2d486b9bd6f89857d2bb054132088984ff602ff60" => :yosemite
    sha256 "fe0010433e950aed71bb6e051af170a451c0f9a9db165eb4da039c5617792f95" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("six").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert File.exist? "scrubbed.svg"
  end
end
