class Pipsi < Formula
  desc "Install python scripts with pip into isolated virtualenvs"
  homepage "https://github.com/mitsuhiko/pipsi/"
  url "https://pypi.python.org/packages/source/p/pipsi/pipsi-0.9.tar.gz"
  sha256 "688b688cc8a7a76612c0d4d1839aaef98ece8382d4382b9d8b6f0caa65f0ed34"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.2.tar.gz"
    sha256 "fba0ff70f5ebb4cebbf64c40a8fbc222fb7cf825237241e548354dabe3da6a82"
  end

  resource "virtualenv" do
    url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.0.3.tar.gz"
    sha256 "355e46928c2b00b83b7d00d70d5adc529e9c2fe1f366b07e8a1b49cd8c5bd1b9"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-8.0.2.tar.gz"
    sha256 "46f4bd0d8dfd51125a554568d646fe4200a3c2c6c36b9f2d06d2212148439521"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click virtualenv pip].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/pipsi", "install", "pygments"
    system "#{bin}/pipsi", "list"
  end
end
