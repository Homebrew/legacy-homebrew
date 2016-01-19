class Tachyon < Formula
  desc "Memory-centric storage system for data sharing across cluster frameworks"
  homepage "http://tachyon-project.org/"
  url "http://tachyon-project.org/downloads/files/0.8.2/tachyon-0.8.2-bin.tar.gz"
  sha256 "52823ba1b5764a3c4be6738a0becb80d88de636bb605310718f6bf0fdbb632a0"

  bottle :unneeded

  def install
    doc.install Dir["docs/*"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

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
