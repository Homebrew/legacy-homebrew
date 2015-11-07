class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "http://www.finnie.org/software/2ping/"
  url "http://www.finnie.org/software/2ping/2ping-3.0.1.tar.gz"
  sha256 "d6997cd1680151e6f7d5e60137d45cd41bf385d26029878afdaaf5dc4f63dcc4"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"2ping", "-c", "5", "test.2ping.net"
  end
end
