class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.org/en/latest/"
  url "https://pypi.python.org/packages/source/d/doitlive/doitlive-2.4.0.tar.gz"
  sha256 "68c9a337dc24f31359ed516d94b662b6467939a20096d76ed75ebed8a2b1a34c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7b5d58667924cc89c35ea5678ce0703d7447e91e15dd198e57ea661de465664" => :el_capitan
    sha256 "ed831e592b1c96ae6d430ba8a11a709cae7057750af88b76b93e7a84f93ce192" => :yosemite
    sha256 "da8dea711c86b98bfca352014d7f7b7285e95406dc8e991d0fd288f7140320f9" => :mavericks
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
