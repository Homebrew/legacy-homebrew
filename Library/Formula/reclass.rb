require "formula"

class Reclass < Formula
  homepage "http://reclass.pantsfullofunix.net/"
  head "https://github.com/madduck/reclass.git"
  url "https://github.com/madduck/reclass/archive/reclass-1.3.tar.gz"
  sha1 "eaa8eb1fd22aa040fa7a57c613c6223706904578"

  bottle do
    cellar :any
    sha1 "3d873a3abf8dddae3f5c075ca635fc3cd9f88b1c" => :mavericks
    sha1 "0724d342a8a3ef4467e3fb9d735635765dca5186" => :mountain_lion
    sha1 "edbe08b22abb9ab9ef9d3a964cbd8abb029f74a0" => :lion
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
