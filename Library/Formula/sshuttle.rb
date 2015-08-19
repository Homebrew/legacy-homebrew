class Sshuttle < Formula
  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle/archive/sshuttle-0.71.tar.gz"
  sha256 "62f0f8be5497c2d0098238c54e881ac001cd84fce442c2506ab6d37aa2f698f0"

  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any
    sha256 "1b759a0906561923790010588e9021985fad41a46f62715bbbe3161289135c56" => :yosemite
    sha256 "1cd57390faf6c628fc7edd60b9dad0030e705477efa47f50c280723549b73058" => :mavericks
    sha256 "7187a29546982362e87cdab10e4aedeb1b5bda7c0ddf40740602534151912133" => :mountain_lion
  end

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"src/sshuttle"
  end
end
