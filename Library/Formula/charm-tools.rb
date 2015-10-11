class CharmTools < Formula
  desc "Tools for authoring and maintaining juju charms"
  homepage "https://launchpad.net/charm-tools"
  url "https://launchpad.net/charm-tools/1.7/1.7.1/+download/charm-tools-1.7.1.tar.gz"
  sha256 "0463f46eb9e4a2a9d2308d79845d9837bce031db668f9012319c714e8ddadbac"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed4f2472ec3404d4f0fc8472eee0128a472132b194c3f4c8d2509e8ab33e4207" => :el_capitan
    sha256 "b9d70fa7b1a6375988cada16f1fb60944093e7697cc35a48b5e250164acd0734" => :yosemite
    sha256 "8b4cf466fd90d6ee807d315d277fa61579ca187961ed48674476e62e38b92224" => :mavericks
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
