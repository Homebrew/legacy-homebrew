class Httpie < Formula
  homepage "https://github.com/jakubroztocil/httpie"
  url "https://github.com/jakubroztocil/httpie/archive/0.9.2.tar.gz"
  sha1 "39e9aab7f6f27973098c22c81fe5b9e7a5866a8b"

  head "https://github.com/jakubroztocil/httpie.git"

  bottle do
    cellar :any
    sha1 "28655be4c5b1fc92442fc0fa200885954dcfda78" => :yosemite
    sha1 "0c4b128c92b0db204fccad5bd9efbd96a6781817" => :mavericks
    sha1 "388f9fdd1f34aec25131cb3d4d67a9164abef406" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.2.tar.gz"
    sha1 "888e788f9e2343f297ae850b13f38b3b3416d3dc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pygments requests].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/http https://raw.githubusercontent.com/Homebrew/homebrew/master/Library/Formula/httpie.rb")
    assert output.include?("PYTHONPATH")
  end
end
