class Httpie < Formula
  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://github.com/jakubroztocil/httpie"
  url "https://github.com/jakubroztocil/httpie/archive/0.9.2.tar.gz"
  sha256 "1f0b0b6563de25bad0ed190d62f1130573124201382824756d015b1422a234cc"
  revision 1

  head "https://github.com/jakubroztocil/httpie.git"

  bottle do
    cellar :any
    sha256 "b8fc458dec0f25a47998302c0bdb1c1914a415e023dbd7f3f0cb90dbbd9ca208" => :yosemite
    sha256 "24d33a99c527f2e8353d1a913106ec9fa78dd422aabecfa7289a7d324dfb9076" => :mavericks
    sha256 "b8489da61c51c9cdca81dbedbb39f2c36f7f50d532c0cea4520d3751ac47a06a" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
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
