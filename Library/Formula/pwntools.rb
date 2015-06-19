class Pwntools < Formula
  desc "CTF framework used by Gallopsled in every CTF"
  homepage "http://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/2.2.0.tar.gz"
  sha256 "67bfaf6e1e24812fdde5093422c6c76bcd581f4b85760779b823b75950817a2d"
  revision 1

  bottle do
    cellar :any
    sha256 "c4df287c8c1e517cc9fd5c4af69bf7e033e4caf6ee1d7f8d78cb851ad3be39ea" => :yosemite
    sha256 "635953d990da1bf6d9852a91896ece40985142327a697df39db4762e776773a5" => :mavericks
    sha256 "3f467927423abadcf73f516b31a51c3dfa33daaeecfddc9f02e19432de4d038a" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "binutils" => :recommended

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha1 "754ffa47fd6f78b93fc56437cf14a79bef094f0f"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha1 "8a8d6c9624669055c2c4f70adcb129139dc50ee6"
  end

  resource "mako" do
    url "https://pypi.python.org/packages/source/M/Mako/Mako-1.0.0.tar.gz"
    sha1 "580b3a8043833e3c3340d4b661a33f6ccc6a35d5"
  end

  resource "pyelftools" do
    url "https://pypi.python.org/packages/source/p/pyelftools/pyelftools-0.23.tar.gz"
    sha1 "4639467a51b1edc8c279468c6b42446f414166ea"
  end

  # Don't bump this beyond 2.1.
  resource "capstone" do
    url "https://pypi.python.org/packages/source/c/capstone/capstone-2.1.tar.gz"
    sha1 "9f40f5421a8fcc3ae9e8b7b424ae742f32bc1b27"
  end

  resource "ropgadget" do
    url "https://github.com/JonathanSalwan/ROPgadget/archive/v5.3.tar.gz"
    sha1 "09087bc89b2b07939e60cd27b034ef5c26eacbb7"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/source/p/pyserial/pyserial-2.7.tar.gz"
    sha1 "f15694b1bea9e4369c1931dc5cf09e37e5c562cf"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.0.tar.gz"
    sha1 "bc4d6d7641afa2f9619121da5194cba83098341a"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha1 "f732f8cdb064bbe47aa830cc2654688da95b78f0"
  end

  # Don't bump this beyond 2.3.
  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.3.tar.gz"
    sha1 "96b33b77e729893bd0837a09a6aa7a12b5070037"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[paramiko argparse mako pyelftools capstone ropgadget pyserial requests psutil markupsafe ecdsa pycrypto].each do |r|
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
    ENV["TERM"] = "xterm"
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
      shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
