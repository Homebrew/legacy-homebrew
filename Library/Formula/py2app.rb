class Py2app < Formula
  desc "Create standalone Mac OS X applications with Python"
  homepage "https://pypi.python.org/pypi/py2app/"
  url "https://pypi.python.org/packages/source/p/py2app/py2app-0.9.tar.gz"
  sha256 "7922672f9e99b50ed931780d43405ac134988b1532dd0659ef130b824f88c59d"

  resource "altgraph" do
    url "https://pypi.python.org/packages/source/a/altgraph/altgraph-0.12.tar.gz"
    sha256 "b90db0dba36d9ece282b6a95ae3d324b63239694ce2cf2fd07d3efd7f2f7cab2"
  end

  resource "macholib" do
    url "https://pypi.python.org/packages/source/m/macholib/macholib-1.7.tar.gz"
    sha256 "1865bed8c50131649653d82cd1fbeb73a36a51355c48c81debdc195387b8103a"
  end

  resource "modulegraph" do
    url "https://pypi.python.org/packages/source/m/modulegraph/modulegraph-0.12.1.tar.gz"
    sha256 "8b278c56f962883986b1a3c8b963ace017553e66fce06a523b59c15c971971a3"
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[altgraph modulegraph macholib].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "example.py"
    system "py2applet", "--make-setup", "example.py"
  end
end
