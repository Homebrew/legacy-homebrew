require "formula"

class Doitlive < Formula
  homepage "http://doitlive.readthedocs.org/en/latest/"
  url "https://pypi.python.org/packages/source/d/doitlive/doitlive-2.3.0.tar.gz"
  sha1 "e2729b81828966c775f396be8845da2c98f129cc"

  bottle do
    cellar :any
    sha1 "5394798b68c5b88c4c9f475d0e01b7580fab87a0" => :yosemite
    sha1 "3858f782fcc37f8035986636503f6db86bb12f0e" => :mavericks
    sha1 "6b21ff9348022970a5089b16420f1ab5e0def101" => :mountain_lion
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
