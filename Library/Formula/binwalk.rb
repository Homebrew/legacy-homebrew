class Binwalk < Formula
  homepage "http://binwalk.org/"
  revision 1
  stable do
    url "https://github.com/devttys0/binwalk/archive/v2.0.1.tar.gz"
    sha256 "90ee8426d71e91b62dfe4a1446c457bc7835b475b28717859e275a0494403959"
  end

  bottle do
    revision 1
    sha256 "93ee55895ace7e0dc5f0acacd763b7233993205250a40484d2a369abc1a8b09a" => :yosemite
    sha256 "f7c486829bdec2d762fccc6a40e737fa224db3a33160a47ba634c202a9905f0a" => :mavericks
    sha256 "224b9a15eb5381132b65196f3748ddd19ab5f4b3375a0a7e846d212dddbf1a41" => :mountain_lion
  end

  head do
    url "https://github.com/devttys0/binwalk.git"

    option "with-capstone", "Enable disasm options via capstone"
    resource "capstone" do
      url "https://pypi.python.org/packages/source/c/capstone/capstone-3.0.2.tar.gz"
      sha256 "b32022fe956e940f8e67c17841dd3f6f1c50a60e451f9b5ce1f4dd2e5c5b3339"
    end
  end

  option "with-matplotlib", "Check for presence of matplotlib, which is required for entropy graphing support"

  depends_on "swig" => :build
  depends_on :fortran
  depends_on "libmagic" => "with-python"
  depends_on "matplotlib" => :python if build.with? "matplotlib"
  depends_on "pyside"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "p7zip"
  depends_on "ssdeep"
  depends_on "xz"

  resource "pyqtgraph" do
    url "http://www.pyqtgraph.org/downloads/pyqtgraph-0.9.10.tar.gz"
    sha256 "4c0589774e3c8b0c374931397cf6356b9cc99a790215d1917bb7f015c6f0729a"
  end

  resource "numpy" do
    url "https://downloads.sourceforge.net/project/numpy/NumPy/1.9.2/numpy-1.9.2.tar.gz"
    sha256 "325e5f2b0b434ecb6e6882c7e1034cc6cdde3eeeea87dbc482575199a6aeef2a"
  end

  resource "scipy" do
    url "https://downloads.sourceforge.net/project/scipy/scipy/0.15.1/scipy-0.15.1.tar.gz"
    sha256 "a212cbc3b79e9a563aa45fc5c517b3499198bd7eb7e7be1e047568a5f48c259a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    res = %w[numpy scipy pyqtgraph]
    res += %w[capstone] if build.with? "capstone"
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if build.head?
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(libexec)
      bin.install Dir["#{libexec}/bin/*"]
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    else
      system "./configure", "--prefix=#{prefix}", "--disable-bundles"
      system "make", "install"
    end
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
