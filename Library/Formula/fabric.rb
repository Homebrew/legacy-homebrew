class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.10.1.tar.gz"
  sha1 "8ce104f6a66ed62e1fe057a6a9e6da0f02eb464a"

  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any
    revision 1
    sha1 "e500fd3a80a2492c2c51792e5f39ff6638416280" => :yosemite
    sha1 "7fbb18fc9647d46e2b0a18132d38835399f1d55a" => :mavericks
    sha1 "176cd8c7889ca1dfea0a0c91c628f1919ec13e1b" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha1 "754ffa47fd6f78b93fc56437cf14a79bef094f0f"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha1 "aeda3ed41caf1766409d4efc689b9ca30ad6aeb2"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha1 "f732f8cdb064bbe47aa830cc2654688da95b78f0"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"fabfile.py").write <<-EOS.undent
    def hello():
        print("Hello world!")
    EOS
    assert_equal "Hello world!\n\nDone.\n", `#{bin}/fab hello`
  end
end
