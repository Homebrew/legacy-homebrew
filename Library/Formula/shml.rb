class Shml < Formula
  desc "Style Framework for The Terminal"
  homepage "http://shml.xyz"
  url "https://github.com/MaxCDN/shml/archive/1.0.4.tar.gz"
  sha256 "583fefbbf2adf45d989b052696be0f20f695903878558a4d2e9f74255b91ed51"

  def install
    bin.install "shml.sh"
    bin.install_symlink bin/"shml.sh" => "shml"
  end

  test do
    assert_match "1.0.4", pipe_output("#{bin}/shml", "-v")
    assert_match "1.0.4", pipe_output("#{bin}/shml.sh", "-v")
  end
end
