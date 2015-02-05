class PythonVirtualenv < Formula
  homepage "https://virtualenv.pypa.io/"
  url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-12.0.6.tar.gz"
  version "12.0.6"
  sha1 "0bb156834a60cc75763eb7c859383d6b86d4ac0c"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"virtualenv", testpath/"venv"
  end
end
