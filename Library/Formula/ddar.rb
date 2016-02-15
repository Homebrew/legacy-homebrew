class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 1

  head "https://github.com/basak/ddar.git"

  depends_on "xmltoman" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  def install
    system "make", "-f", "Makefile.prep", "pydist"
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir["*.1"]
  end
end
