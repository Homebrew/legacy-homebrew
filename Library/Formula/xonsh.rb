class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xonsh.org"
  url "https://github.com/scopatz/xonsh/archive/0.2.2.tar.gz"
  sha256 "cd37fafb53ca18474132929117df02cfbf53526345183027f773db5b45bb7759"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08e216889fb6eede6e0db765d8f541fd53532a23d926d0a58bd59871cc1b43d1" => :el_capitan
    sha256 "7c689d405aee2fb02aa94605ee0857e271e5ef083b5728a1ffa0b722d6ef9be0" => :yosemite
    sha256 "142e2c7688f3e1f776900193d2f3bcb4157212435cf29a46cd05144b8b00b9ed" => :mavericks
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/source/p/ply/ply-3.8.tar.gz"
    sha256 "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"
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
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
