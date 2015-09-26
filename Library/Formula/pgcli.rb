class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "http://pgcli.com/"
  url "https://pypi.python.org/packages/source/p/pgcli/pgcli-0.19.1.tar.gz"
  sha256 "0d383203279be0b7fff469b55de88a4ed540290fd6b1292d64aa1f0923b76217"

  bottle do
    cellar :any
    sha256 "60898118f2ece21d8dfd5fb2c68c081db4e5b81ed72cb63708dabb9d79988a1a" => :el_capitan
    sha256 "cfb848bc7c8c55209b8610047d67b2fa21125ff68fc37b2a9cdb30ed70522ce6" => :yosemite
    sha256 "e8cfd69a6839f114d0b25823d4484a311af1e840c859d63ba5642fcb85bad9ca" => :mavericks
    sha256 "8a0be06ff9e0194ebd04458ac9c30de1d3b39c103e75ba33050fa06774c38d71" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on :postgresql

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.1.tar.gz"
    sha256 "e339ed09f25e2145314c902a870bc959adcb25653a2bd5cc1b48d9f56edf8ed8"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.45.tar.gz"
    sha256 "553fd2b9169674adacf227ede2e056c2bbd7181a4a3ca614960467c0720997a6"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.6.1.tar.gz"
    sha256 "6acf9abbbe757ef75dc2ecd9d91ba749547941abaffbe69ff2086a9e37d4904c"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.14.tar.gz"
    sha256 "e561e31853ab9f3634a1a2bd53035f9e47dfb203d56b33cc6569047ba087daf0"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.4.tar.gz"
    sha256 "906d3123045d77027b49fe912458e1a1e1d6ca1a51558a4bd9168d143b129d2b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit psycopg2 sqlparse Pygments wcwidth six configobj].each do |r|
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
    system bin/"pgcli", "--help"
  end
end
