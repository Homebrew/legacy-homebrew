class Ngender < Formula
  homepage "https://github.com/observerss/ngender"
  url "https://pypi.python.org/packages/source/n/ngender/ngender-0.1.0.tar.gz"
  version "0.1.0"
  sha256 "6c651ba2b54da0d8e170362317e4f4b11de1bfa4972a2cb04ba1779a75e8227b"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output(bin/"ng 赵本山")
    assert output.include? "male"
  end
end
