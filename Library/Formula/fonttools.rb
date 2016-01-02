class Fonttools < Formula
  desc "FontTools is a library for manipulating fonts"
  homepage "https://github.com/behdad/fonttools"
  url "https://github.com/behdad/fonttools/archive/3.0.tar.gz"
  sha256 "3bc9141d608603faac3f800482feec78a550d0a94c29ff3850471dbe4ad9e941"
  head "https://github.com/behdad/fonttools.git"

  bottle do
    cellar :any
    sha256 "bc27fdc1e14b66cfb679a782cbd80a339cd862be2f0af5b27c16899a6fb4a008" => :yosemite
    sha256 "7803a3c15c7ab4e1a2a9ceb832ff7ce948c16336dea4d75a8100e503e88d3b9d" => :mavericks
    sha256 "2dc603eb4e24251d2241d6c9449e9284502432358bd0a63e0f0fc64c09069ff5" => :mountain_lion
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages/FontTools"

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
