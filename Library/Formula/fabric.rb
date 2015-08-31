class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.10.2.tar.gz"
  sha256 "f142aca5a20624036a35faa387dd5c409ad534a130f39172115fd57d7e9c3a8d"

  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any
    sha256 "ddaccc0db8c861b4f1d5d0fec3d845ff440f86af3a28751a299ad7784253ba1d" => :yosemite
    sha256 "044c9dec4d5021abd8b4c356e8ff0bfc5968115267b030219f010ff5b97abfbf" => :mavericks
    sha256 "768df88335578704b1029b859ab7d36654cb5b20bfd1b0bc64e487476b7c214e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha256 "4f56a671a3eecbb76e6143e6e4ca007d503a39aa79aa9e14ade667fa53fd6e55"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
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
