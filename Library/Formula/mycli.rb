class Mycli < Formula
  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "http://mycli.net/"
  url "https://pypi.python.org/packages/source/m/mycli/mycli-1.5.2.tar.gz"
  sha256 "55a3529656fda9eb25399c96baa4ab7c46dfc0b24495d6793181af6daa74c092"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ad19c36b2143b99798310ea98800a5b4d34ea5d509616f41bae679472ddc97b" => :el_capitan
    sha256 "f31418db3551f15084194f5c7440321ed76a043753c674fe72c0a0dd30214d13" => :yosemite
    sha256 "d3f258cc59dacf12de4ffd8480fa7de428c727ed595b9c4b273e1f744521ef6e" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.46.tar.gz"
    sha256 "1aa25cb9772e1e27d12f7920b5a514421ab763231067119bbd2f8b1574b409fb"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "PyMySQL" do
    url "https://pypi.python.org/packages/source/P/PyMySQL/PyMySQL-0.6.7.tar.gz"
    sha256 "e549649db3b1a9317c6027175197458bfb4f55357828410ed4f768fc6ce35f0f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.18.tar.gz"
    sha256 "39b196c4a06f76d6ac82f029457ca961f662a8bbbb2694eb1dfe4f2b68a2d7cf"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.5.tar.gz"
    sha256 "66c7ce3199c87833aaaa1fe1241b63261ce53c1062597c189a16a54713e0919d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit pycrypto PyMySQL sqlparse Pygments wcwidth six configobj].each do |r|
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
    system bin/"mycli", "--help"
  end
end
