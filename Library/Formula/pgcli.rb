class Pgcli < Formula
  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "http://pgcli.com/"
  url "https://pypi.python.org/packages/source/p/pgcli/pgcli-0.20.1.tar.gz"
  sha256 "e645d21abf98303259bf588e9afa1bedf507f54ae27f78f0587cce98315421ab"

  bottle do
    cellar :any
    sha256 "c61d08c167b473467e79954decaf7c3f8d78295ee7377958c1f536e6db99ae2c" => :el_capitan
    sha256 "b8e88ed6f1a4c2ce8ca672a96c0e842236f69dc7ad5ff000eadc1fc21e494fc1" => :yosemite
    sha256 "f83f82e184a724ddfb5ba21faab65cf7f5974fe32b534f1cff1a8b85f6f48041" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on :postgresql

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.16.tar.gz"
    sha256 "678c6c36ca4b01405177da8b84eecf92ec92c9f6c762396c965bb5d305f20f81"
  end

  resource "setproctitle" do
    url "https://pypi.python.org/packages/source/s/setproctitle/setproctitle-1.1.9.tar.gz"
    sha256 "1c3414d18f9cacdab78b0ffd8e886d56ad45f22e55001a72aaa0b2aeb56a0ad7"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.6.1.tar.gz"
    sha256 "6acf9abbbe757ef75dc2ecd9d91ba749547941abaffbe69ff2086a9e37d4904c"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.5.tar.gz"
    sha256 "66c7ce3199c87833aaaa1fe1241b63261ce53c1062597c189a16a54713e0919d"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.46.tar.gz"
    sha256 "1aa25cb9772e1e27d12f7920b5a514421ab763231067119bbd2f8b1574b409fb"
  end

  resource "pgspecial" do
    url "https://pypi.python.org/packages/source/p/pgspecial/pgspecial-1.2.0.tar.gz"
    sha256 "36ae9126f50fd146c96609b71a34ffa9122cfb72e658f46114c4cb8642530b17"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit psycopg2 pgspecial sqlparse Pygments wcwidth six setproctitle configobj].each do |r|
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
