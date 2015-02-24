require "formula"

class Fig < Formula
  homepage "http://www.fig.sh/"
  url "https://github.com/docker/fig/archive/1.0.1.tar.gz"
  sha1 "8044dd8134af1215138c1e878cc1684bac8932d9"

  bottle do
    cellar :any
    revision 1
    sha1 "01583c5ed7b5d8bc593d1614801b67eaf8759b40" => :yosemite
    sha1 "5b501d0cb7d839e96723308bded669c9aeab12e3" => :mavericks
    sha1 "8018518bf6266ead170de96e5c838315caa09ddb" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-0.5.3.tar.gz"
    sha1 "11708a7021e3d0d522e145c057256d7d2acaec07"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.3.2.tar.gz"
    sha1 "4b323b7c2fce84452dc5950ff1b32d97d9a412aa"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.1.tar.gz"
    sha1 "ca505fb7424defa99f5a85bdaf433a6b24ffa82c"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha1 "224a3ec08b56445a1bd1583aad06b00692671e04"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha1 "f906c441be2f0e7a834cbf701a72788d3ac3d144"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket-client-0.11.0.tar.gz"
    sha1 "a38cb6072a25b18faf11d31dd415750692c36f33"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/fig", "--version"
  end
end
