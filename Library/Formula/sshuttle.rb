class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle/archive/v0.73.tar.gz"
  sha256 "d78a6aa76f93ab69fd9685ce11b428a9b549c049a6c0104740c06c9b354a5ae3"
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
