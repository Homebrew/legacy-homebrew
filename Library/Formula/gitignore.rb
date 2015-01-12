class Gitignore < Formula
  homepage "https://github.com/karan/joe"
  url "https://github.com/karan/joe/archive/0.0.2.tar.gz"
  sha1 "da3abe49d76a4844d0744951b61c3dd71fd9959c"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://github.com/docopt/docopt/archive/0.6.1.tar.gz"
    sha1 "2228a1bc58665664550a4552fb53906704918866"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    %w[docopt].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/joe", "--version"
  end
end
