class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://pypi.python.org/packages/source/s/sshuttle/sshuttle-0.77.2.tar.gz"
  sha256 "20cc93802bded9efef1efb89a044abd7ef585cafc4da62b4bd83de944b8694bb"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    shell_output("#{bin}/sshuttle -h", 97)
  end
end
