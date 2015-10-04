class Reclass < Formula
  desc "Recursive external node classification"
  homepage "http://reclass.pantsfullofunix.net/"
  head "https://github.com/madduck/reclass.git"
  url "https://github.com/madduck/reclass/archive/reclass-1.4.1.tar.gz"
  sha256 "48271fcd3b37d8945047ed70c478b387f87ffef2fd209fe028761724ed2f97fb"

  bottle do
    cellar :any
    sha1 "4c055763f00605f006fb585f34ccae585b514dc8" => :yosemite
    sha1 "bf1b1acdd4475d3271f8b27eb41b0f414dac6147" => :mavericks
    sha1 "4d1a4805aef3db3858c6d6fa01e982eae3a8cd1b" => :mountain_lion
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
