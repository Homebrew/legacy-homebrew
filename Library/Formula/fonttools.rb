class Fonttools < Formula
  desc "Library for manipulating fonts"
  homepage "https://github.com/behdad/fonttools"
  url "https://github.com/behdad/fonttools/archive/3.0.tar.gz"
  sha256 "3bc9141d608603faac3f800482feec78a550d0a94c29ff3850471dbe4ad9e941"
  head "https://github.com/behdad/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d2aca5663043850875bd16bb04af383eaee14b4b205c8595fbda20ae0867429e" => :el_capitan
    sha256 "2639039f72920032e0dc6ce6faf15b837487c8561936412c437497c23bd248d0" => :yosemite
    sha256 "eaa0a7decad7e731eae45b93364d18bdadbfadcf39f9a14a6f4e78d55f0b757f" => :mavericks
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
