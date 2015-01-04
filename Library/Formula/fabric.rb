class Fabric < Formula
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.10.1.tar.gz"
  sha1 "8ce104f6a66ed62e1fe057a6a9e6da0f02eb464a"

  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any
    sha1 "374785f7ecd2987f93370ff86e884655ccdc8a35" => :yosemite
    sha1 "6047b970eee66ce79fefd33ce49b60805b20db8d" => :mavericks
    sha1 "a75ad6a04ce7becd283ed8ba1a9bc6319025a05d" => :mountain_lion
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
    ENV.prepend_create_path "PYTHONPATH", libexec + "lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix + "lib/python2.7/site-packages"

    res = %w[ecdsa pycrypto paramiko]
    install_args = "setup.py", "install", "--prefix=#{libexec}"
    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{libexec}"

    (bin/"fab").write_env_script libexec/"bin/fab", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    (testpath/"fabfile.py").write <<-EOS.undent
    def hello():
        print("Hello world!")
    EOS
    assert_equal "Hello world!\n\nDone.\n", `#{bin}/fab hello`
  end
end
