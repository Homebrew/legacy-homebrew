class Byteman < Formula
  homepage "http://byteman.jboss.org/"
  url "http://downloads.jboss.org/byteman/2.2.1/byteman-download-2.2.1-bin.zip"
  sha256 "c4f8b5a89163d2ff42f90f6a90025ebd165d1e9046390f97bb5657e4fd1b85bb"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
  end

  test do
    system "#{opt_libexec}/bin/bmcheck.sh"
  end
end
