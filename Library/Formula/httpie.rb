class Httpie < Formula
  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "http://httpie.org/"
  url "https://github.com/jkbrzt/httpie/archive/0.9.3.tar.gz"
  sha256 "2a0c7cf6a6914620eebc2d7700e8e7a57aabde62bd62cd7fa68f8b216c0b2340"

  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df67a9af5d1421a855ce6bfb39f2a6d4a140cd56db85d4daad4b34359178a3a2" => :el_capitan
    sha256 "1efd7954a3ee5b2298e0a615c0c7a115ac427518cff44bc1e6f51049d03f16db" => :yosemite
    sha256 "3e0cca65df7252673a65c8848ee9f780c39ddfbfabfd1f7e5202c4379cb6d929" => :mavericks
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

    bash_completion.install "httpie-completion.bash"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "PYTHONPATH",
      shell_output("#{bin}/http https://raw.githubusercontent.com/Homebrew/homebrew/master/Library/Formula/httpie.rb")
  end
end
