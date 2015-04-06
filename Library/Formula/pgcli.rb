class Pgcli < Formula
  homepage "http://pgcli.com/"
  url "https://pypi.python.org/packages/source/p/pgcli/pgcli-0.16.3.tar.gz"
  sha1 "747e8505514255833738a0ded3809728d942dda7"

  bottle do
    cellar :any
    sha256 "0119d16d4bddd2c18a8780d6423d4f730cb2b0782c753565c3626aa58aa3a78a" => :yosemite
    sha256 "408ac44b598737ad2d240b7a858c9668ab62ed61267ece56577986d09077834b" => :mavericks
    sha256 "0ee3f0a9fe8214615586ba630234511d1c71623fd77bf7d102c258a4adb9efe5" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on :postgresql

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-3.3.tar.gz"
    sha1 "d716a932b930d71059e49465b6b42e833808369a"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.26.tar.gz"
    sha1 "4ca53785d38c396fa4e86453dd625fdd450110b9"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.5.4.tar.gz"
    sha1 "647b51a16a0aab1ead239c38aa5f695fd0159a17"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.14.tar.gz"
    sha1 "117db829bed1ed002717456b8d4516ed522dbd4d"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.1.tar.gz"
    sha1 "b9e9236693ccf6e86414e8578bf8874181f409de"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.4.tar.gz"
    sha1 "ecc43396717b075c13f94889a36464add873976c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "jedi" do
    url "https://pypi.python.org/packages/source/j/jedi/jedi-0.8.1.tar.gz"
    sha1 "cc69ca5f4818ee29f16f08142d79c46c79ee611d"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha1 "224a3ec08b56445a1bd1583aad06b00692671e04"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit psycopg2 sqlparse pygments wcwidth six jedi docopt].each do |r|
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
