class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xonsh.org"
  url "https://github.com/scopatz/xonsh/archive/0.1.5.tar.gz"
  sha256 "ed04665d4396837191594f2dd9107403eabecb14add5dfbb8f4fb31e13fc03c2"
  head "https://github.com/scopatz/xonsh.git"
  revision 1

  bottle do
    cellar :any
    sha256 "b01e69bc7edf7d3c8bb5c0fc82a77d634b11322d87f93370f0eaf7b033a1be36" => :yosemite
    sha256 "c207006622b9b5990f22f972f391e0aee43a95ed98b1f0204c667a3b9f3a6b86" => :mavericks
    sha256 "f228ac9474754634cb55d4916d41f7cc647daa243e8910db1189722a3e2554d7" => :mountain_lion
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
