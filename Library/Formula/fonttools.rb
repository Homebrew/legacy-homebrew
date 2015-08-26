class Fonttools < Formula
  desc "FontTools is a library for manipulating fonts"
  homepage "https://github.com/behdad/fonttools"
  url "https://github.com/behdad/fonttools/archive/2.5.tar.gz"
  sha256 "c89603f9f3346f48f4a24f786422e935423554e0a9172dcd3ec8ffbd556d2159"
  head "https://github.com/behdad/fonttools.git"

  bottle do
    cellar :any
    sha256 "ec7dafb8a42f26a326f2569fd9c9ac20586202ade9869d0558e21362eda42058" => :yosemite
    sha256 "eacf6abd99b4a9038d5635a2d5427e1bb65d5040dc71caf46b9c68950395d702" => :mavericks
    sha256 "ddfe6802322d603209ecd08f64cf65ee3ebaff5a7ff27782a4a79671e8af821c" => :mountain_lion
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
