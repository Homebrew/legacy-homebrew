class CharmTools < Formula
  desc "Tools for authoring and maintaining juju charms"
  homepage "https://launchpad.net/charm-tools"
  url "https://launchpad.net/charm-tools/1.7/1.7.0/+download/charm-tools-1.7.0.tar.gz"
  sha256 "6bc12d24460b366e12176538692d5b29c3697f5c8a98b525a05fa5ec7b04e042"

  bottle do
    cellar :any_skip_relocation
    sha256 "3501cda00eebfa84b6de87d2a3816740cb4756d8682ffb4cc2dd41ecd11f2110" => :el_capitan
    sha256 "cae0728f61d14a01e9adf2246bdba70ca114b1b4b768c5d7e3a434b50c73d474" => :yosemite
    sha256 "f959e49c90a21203f16452ff1ea65e88d40de992fca8551d2c7fb2b3be24a693" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*charm*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/charm", "list"
  end
end
