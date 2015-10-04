class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xonsh.org"
  url "https://github.com/scopatz/xonsh/archive/0.1.5.tar.gz"
  sha256 "ed04665d4396837191594f2dd9107403eabecb14add5dfbb8f4fb31e13fc03c2"
  head "https://github.com/scopatz/xonsh.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0bc48de85eb1b8ca387bb6aa1a5336b4c0111110e68c76ba4806c8c9b87cc098" => :yosemite
    sha256 "1ac713cb81b80a8fc065137b6b200337a9eeca1ebc37be7c712998074f41c35d" => :mavericks
    sha256 "d511c4c1d3c0de59601ea85d62a4b13b4802f22f062791f3464ed4a9b247f694" => :mountain_lion
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/source/p/ply/ply-3.6.tar.gz"
    sha256 "61367b9eb2f4b819f69ea116750305270f1df8859992c9e356d6a851f25a4b47"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resource("ply").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match /4/, shell_output("#{bin}/xonsh -c 2+2")
  end
end
