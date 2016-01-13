class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle/archive/v0.75.tar.gz"
  sha256 "63714287d8f9128eefafe4e1b9fc9c8367490f9d074a2b2ff2f555c46ff794b2"
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
