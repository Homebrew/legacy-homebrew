class ChinadnsC < Formula
  desc "Port of ChinaDNS to C: fix irregularities with DNS in China"
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS/releases/download/1.3.1/chinadns-1.3.1.tar.gz"
  sha1 "3bb6a7dd69c44e99e5794690cbc0efd4b73b7c4b"

  bottle do
    cellar :any
    sha256 "5f4c5283c7230f2a7368da43db1a5ac6c5b4adadb4dea9a2e601dfa97d3b5337" => :yosemite
    sha256 "3b0298252c265079645530d03ab1ebdd784aabdd2445aa0b3dbdf75f93d47b2e" => :mavericks
    sha256 "1c6594b10d571de1d838869f684fef343c6da4431cfc1294e0950ee19f823f00" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "chinadns", "-h"
  end
end
