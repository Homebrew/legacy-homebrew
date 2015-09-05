class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language."
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://pypi.python.org/packages/source/x/xdot/xdot-0.6.tar.gz"
  sha256 "c71d82bad0fec696af36af788c2a1dbb5d9975bd70bfbdc14bda15b5c7319e6c"

  head "https://github.com/jrfonseca/xdot.git"

  bottle do
    cellar :any
    sha256 "9cf28bdc65d88717d0d7bac2f4aa8d2481dc1fbae3d0bb0ccd3966f27134fa2d" => :yosemite
    sha256 "cc1909be49ac10c929613451862498c817fe691a60c49ae6bb5eeef4ee122d66" => :mavericks
    sha256 "041b79d9ca753ec9005c7485417da74e5595ceadc4a6288dbe5c51d298e2886a" => :mountain_lion
  end

  depends_on "graphviz"
  depends_on "pygtk"
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
