class Imply < Formula
  desc "Repackages Druid with additional components that make it easier to use"
  homepage "https://github.com/implydata"
  url "http://static.imply.io/release/imply-1.1.0.tar.gz"
  sha256 "d06add07832c4253f0f3722b1625d034c52f3d9041e59779a277b72a84d1ce53"

  bottle :unneeded

  def install
    mv "bin/service", "bin/imply-service"
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS.undent
      To avoid conflicting with other binaries,
      #{bin}/service has been renamed to
      #{bin}/imply-service
    EOS
  end

  test do
    assert_match(/^usage:/, shell_output("#{bin}/imply-service 2>&1", 255))
  end
end
