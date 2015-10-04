class Whirr < Formula
  desc "Set of libraries for running cloud services"
  homepage "https://whirr.apache.org/"
  url "https://archive.apache.org/dist/whirr/whirr-0.8.2/whirr-0.8.2.tar.gz"
  sha256 "d5ec36c4a6928079118065e3d918679870a42c844e47924b1cd4d7be00a4aca5"

  def install
    libexec.install %w[bin conf lib]
    bin.write_exec_script libexec/"bin/whirr"
  end

  test do
    system "#{bin}/whirr", "help", "help"
  end
end
