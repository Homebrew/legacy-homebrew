class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "http://www.finnie.org/software/2ping/"
  url "http://www.finnie.org/software/2ping/2ping-3.0.1.tar.gz"
  sha256 "d6997cd1680151e6f7d5e60137d45cd41bf385d26029878afdaaf5dc4f63dcc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "115f515900391449e9f22602744c680ea54451f534cac89eddb4bc133f38c6cb" => :el_capitan
    sha256 "01b54ba53327fa3c8da79add6ee0bc9549f7b2f8ee18cf340f30049b17388719" => :yosemite
    sha256 "dbc7b643c3cea44b8e00956d530244f7722c0d3ccebcec34913a3051d5cd348e" => :mavericks
  end

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
