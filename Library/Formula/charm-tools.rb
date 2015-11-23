class CharmTools < Formula
  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://github.com/juju/charm-tools/releases/download/v1.8.0/charm-tools-1.8.0.tar.gz"
  sha256 "e72e788f069fcf4c2db7435db71ca8feb3dd8c6fd63c4b7e591b4064d76f4dbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed3e5be4e4f379e2aca09a79a7f6a81225b7eb0c21266bf81ad048a9781d980e" => :el_capitan
    sha256 "94cd704a118c3792103234da7cc981466a0186a7d41333761d9a4335b7a927e0" => :yosemite
    sha256 "7e9dda9b12a176005c2ef5293cc001088cede449dc44cae09f0a24dd309c276a" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
    sha256 "ca047986f0528cfa975a14fb9f7f106271d4e0c3fe1ddced6c1db2e7ae57a477"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pip].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*charm*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/charm", "list"
  end
end
