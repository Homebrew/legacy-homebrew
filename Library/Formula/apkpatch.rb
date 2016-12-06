class Apkpatch < Formula
  desc "Tool for build/merge Android Patch file (.apatch)"
  homepage "https://github.com/alibaba/AndFix"
  url "https://raw.githubusercontent.com/alibaba/AndFix/master/tools/apkpatch-1.0.3.zip"
  sha256 "0f94cd2a675af89ff3990f4b6490dd70877ad4eb109f0cdbefece1f9a73e4512"

  depends_on :java

  def install
    rm_rf Dir["*.bat"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.sh") do |script|
      bin.install_symlink script => File.basename(script, ".sh")
    end
  end

  test do
    system "#{bin}/apkpatch", "help"
  end
end
