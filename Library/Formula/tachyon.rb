class Tachyon < Formula
  desc "A memory-centric storage system for data sharing across cluster frameworks"
  homepage "http://tachyon-project.org/"
  url "http://tachyon-project.org/downloads/files/0.8.1/tachyon-0.8.1-bin.tar.gz"
  sha256 "82c289b49fdd29a8969c404203d20ac29f7136a3af72597f25537a9263cf0c74"

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
