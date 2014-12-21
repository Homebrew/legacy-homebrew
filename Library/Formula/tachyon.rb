class Tachyon < Formula
  homepage "http://tachyon-project.org/"
  url "https://github.com/amplab/tachyon/releases/download/v0.5.0/tachyon-0.5.0-bin.tar.gz"
  sha1 "3e83f7ea7ca262689bac8acd51b6bff0cce0a1df"

  def install
    libexec.install %w[bin client conf core libexec]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    doc.install Dir["docs/*"]
  end

  test do
    system bin/"tachyon", "version"
  end

  def caveats; <<-EOS.undent
    Before starting, you must create your conf file from the template:
      #{libexec}/conf/tachyon-env.sh.template
    by copying it to:
      #{libexec}/conf/tachyon-env.sh
    EOS
  end
end
