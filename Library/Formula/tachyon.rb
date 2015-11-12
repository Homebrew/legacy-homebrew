class Tachyon < Formula
  desc "Distributed storage system to enable data sharing across cluster frameworks"
  homepage "http://tachyon-project.org/"
  url "https://github.com/amplab/tachyon/releases/download/v0.6.4/tachyon-0.6.4-bin.tar.gz"
  sha256 "c105e2e984cc7139933e1d1debc4b393fe22ef33fb90776edc5be7148829b820"

  bottle :unneeded

  def install
    libexec.install %w[bin client conf core libexec]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    doc.install Dir["docs/*"]

    (etc/"tachyon").install libexec/"conf/tachyon-env.sh.template" => "tachyon-env.sh"
    ln_sf "#{etc}/tachyon/tachyon-env.sh", "#{libexec}/conf/tachyon-env.sh"
  end

  def caveats; <<-EOS.undent
    To configure tachyon, edit
      #{etc}/tacyon/tachyon-env.sh
    EOS
  end

  test do
    system bin/"tachyon", "version"
  end
end
