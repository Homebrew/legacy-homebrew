require "formula"

class Fig < Formula
  homepage "http://www.fig.sh/"
  url "https://github.com/docker/fig/archive/1.0.0.tar.gz"
  sha1 "66b79dae588e281656b4a91b54512af4a09e9eea"

  bottle do
    cellar :any
    sha1 "0562c46ab9b0d73501e7a47dd7fb70136fe5863b" => :mavericks
    sha1 "91643cd7ea3c476e639d9596f3f77e37f19107ef" => :mountain_lion
    sha1 "0c285d35df9ae454e4a13ff135ec8d35230dfb4a" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.1.tar.gz"
    sha1 "3d0ad1cf495d2c801327042e02d67b4ee4b85cd4"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha1 "476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.2.1.tar.gz"
    sha1 "88eb1fd6a0dfb8b97262f8029978d7c75eebc16f"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.1.tar.gz"
    sha1 "ca505fb7424defa99f5a85bdaf433a6b24ffa82c"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.11.0.tar.gz"
    sha1 "a38cb6072a25b18faf11d31dd415750692c36f33"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.2.1.tar.gz"
    sha1 "6edf60955c274ee258ba4fe1ea7233c252fd179b"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm "#{lib}/python2.7/site-packages/site.py"
    rm "#{lib}/python2.7/site-packages/easy-install.pth"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/fig", "--version"
  end
end
