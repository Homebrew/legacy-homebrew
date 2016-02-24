class Reclass < Formula
  desc "Recursive external node classification"
  homepage "http://reclass.pantsfullofunix.net/"
  head "https://github.com/madduck/reclass.git"
  url "https://github.com/madduck/reclass/archive/reclass-1.4.1.tar.gz"
  sha256 "48271fcd3b37d8945047ed70c478b387f87ffef2fd209fe028761724ed2f97fb"

  bottle do
    cellar :any
    sha256 "9777a5365e3bbce9eb30d7cc174e9fefbf2a38c52560ea15ca7a83145fa0547a" => :yosemite
    sha256 "72260fdea312b34878863a7aaa9f8f64f731d0fc5df2825d9447ee73ad5969eb" => :mavericks
    sha256 "9a58dbd778a4ae0cb83c3394b8a3b2638d9d2562789be744a95e1a7254ed7de7" => :mountain_lion
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
