class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.org/en/latest/"
  url "https://pypi.python.org/packages/source/d/doitlive/doitlive-2.4.0.tar.gz"
  sha256 "68c9a337dc24f31359ed516d94b662b6467939a20096d76ed75ebed8a2b1a34c"

  bottle do
    cellar :any
    sha1 "8bdb41603a087ccb0b3f50e56e37a60eacdd46c7" => :yosemite
    sha1 "1b976835aa074897a4aa5b3e8828813aaf3bb718" => :mavericks
    sha1 "89faad888461a236a24a6964a0df58bb05c5496d" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
