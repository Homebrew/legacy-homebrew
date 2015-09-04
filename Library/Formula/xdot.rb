class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language."
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://pypi.python.org/packages/source/x/xdot/xdot-0.6.tar.gz"
  sha256 "c71d82bad0fec696af36af788c2a1dbb5d9975bd70bfbdc14bda15b5c7319e6c"

  head "https://github.com/jrfonseca/xdot.git"

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
