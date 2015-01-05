class Redpen < Formula
  homepage "http://redpen.cc/"
  url "https://github.com/recruit-tech/redpen/releases/download/v1.0.1/redpen-cli-1.0.1.tar.gz"
  sha1 "df0324348af5e07840454cd088ea7d26f490e6bf"

  depends_on :java => "1.8"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w(bin conf lib sample-doc)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/redpen", "version"
  end
end
