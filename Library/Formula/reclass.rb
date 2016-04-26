class Reclass < Formula
  desc "Recursive external node classification"
  homepage "http://reclass.pantsfullofunix.net/"
  url "https://github.com/madduck/reclass/archive/reclass-1.4.1.tar.gz"
  sha256 "48271fcd3b37d8945047ed70c478b387f87ffef2fd209fe028761724ed2f97fb"
  head "https://github.com/madduck/reclass.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "92c143420d36d71d49ecde69eca47da2a46f1ae6d37e0f7522cb95a9d19735e7" => :el_capitan
    sha256 "7be55ff36c5e4b02e3bf2c6ea297e8a3248452dc6b15c1e6fd77633373ff3bb3" => :yosemite
    sha256 "7c63989f940dc69a54c8e1eebb1d14a1ea04141a4a806354ed1ad338c8d4ea6b" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/reclass", "--version"
  end
end
