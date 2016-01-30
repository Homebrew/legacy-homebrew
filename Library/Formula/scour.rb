class Scour < Formula
  desc "SVG file scrubber"
  homepage "http://www.codedread.com/scour/"
  url "https://github.com/codedread/scour/archive/v0.33.tar.gz"
  sha256 "e9b4fb4beb653afbdbc43c4cc0836902d6f287d882b6b7cdf714c456ff0841a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e20386a449eee13ff8efd15b517b0f259a69699876b9698e48a0a4d3e0854503" => :el_capitan
    sha256 "46b84524f4551881018c7c9ef2f3e82e99b875de44b63e21328d69b0df731761" => :yosemite
    sha256 "dbc08567e8e78e9020417f859c0e97dbd93314174c2a6fa5bcf4234de1ded610" => :mavericks
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
