class StormpathCli < Formula
  desc "Command-line interface for https://stormpath.com/ user management"
  homepage "https://github.com/stormpath/stormpath-cli"
  url "https://github.com/stormpath/stormpath-cli/archive/0.0.2.tar.gz"
  sha256 "50e334cb48cd0f9c0abdf77c1aa577c1d900547d8be39155d2248b995c044b0e"
  head "https://github.com/stormpath/stormpath-cli.git"

  depends_on :python

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz#md5=4bc74561b37fad5d3e7d037f82a4c3b1"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "stormpath" do
    url "https://pypi.python.org/packages/source/s/stormpath/stormpath-2.1.6.tar.gz#md5=1b1fe1a9980b66d58249d152b7d66273"
    sha256 "48e6f30b50a04678be80dd759237188adea108a29ebbf1343b64bead22bafb17"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[docopt stormpath].each do |r|
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
    system "#{bin}/stormpath", "--help"
  end
end
