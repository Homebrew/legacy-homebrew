class Dex2jar < Formula
  desc "Tools to work with Android .dex and Java .class files"
  homepage "https://github.com/pxb1988/dex2jar"
  url "https://downloads.sourceforge.net/project/dex2jar/dex2jar-2.0.zip"
  mirror "https://bitbucket.org/pxb1988/dex2jar/downloads/dex2jar-2.0.zip"
  sha256 "7907eb4d6e9280b6e17ddce7ee0507eae2ef161ee29f70a10dbc6944fdca75bc"

  bottle :unneeded

  def install
    # Remove Windows scripts
    rm_rf Dir["*.bat"]

    # Install files
    prefix.install_metafiles
    chmod 0755, Dir["*"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.sh") do |script|
      bin.install_symlink script => File.basename(script, ".sh")
    end
  end

  test do
    system bin/"d2j-dex2jar", "--help"
  end
end
