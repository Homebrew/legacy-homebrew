class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "http://nescc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nescc/nescc/v1.3.5/nesc-1.3.5.tar.gz"
  sha256 "c22be276d565681a2b84ddbf2a037256d24ecbf0da35e30157589609eec63096"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa7e61956f6b0e505ff4ed31ecd53e1d9f007b062f0efc94d34485667525dabf" => :el_capitan
    sha256 "587202b38e19508979e0bf7ad05144cb1d82e27cbdde7bc626798947caeb1288" => :yosemite
    sha256 "e39de1a28a7459f5948826bb8533c4adf1e2efe76eb7230a1dd8de00eb625cb7" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
