class Httpie < Formula
  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "http://httpie.org/"
  url "https://github.com/jkbrzt/httpie/archive/0.9.3.tar.gz"
  sha256 "2a0c7cf6a6914620eebc2d7700e8e7a57aabde62bd62cd7fa68f8b216c0b2340"

  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d707a541466d018c25214ac5c37db81be6f3c55f9a8a7ddfb4e9a40771e207e0" => :el_capitan
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
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
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
    assert_match "PYTHONPATH",
      shell_output("#{bin}/http https://raw.githubusercontent.com/Homebrew/homebrew/master/Library/Formula/httpie.rb")
  end
end
