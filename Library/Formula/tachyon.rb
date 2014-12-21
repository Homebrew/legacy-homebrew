class Tachyon < Formula
  homepage "http://tachyon-project.org/"
  url "https://github.com/amplab/tachyon/releases/download/v0.5.0/tachyon-0.5.0-bin.tar.gz"
  sha1 "3e83f7ea7ca262689bac8acd51b6bff0cce0a1df"

  def install
    mkdir_p "#{etc}/tachyon"
    libexec.install %w[bin client conf core libexec]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    doc.install Dir["docs/*"]

    unless File.exist?("#{etc}/tachyon/tachyon-env.sh")
      cp "#{libexec}/conf/tachyon-env.sh.template", "#{etc}/tachyon/tachyon-env.sh"
    end
    ln_sf "#{etc}/tachyon/tachyon-env.sh", "#{libexec}/conf/tachyon-env.sh"
  end

  test do
    system bin/"tachyon", "version"
  end

  def caveats; <<-EOS.undent
    Before starting, make sure you set TACHYON_UNDERFS_ADDRESS in
      #{etc}/tacyon/tachyon-env.sh
    to some tmp directory in your local filesystem, e.g. /tmp.
    EOS
  end
end
