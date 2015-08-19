class GitTf < Formula
  desc "Share changes between TFS and git"
  homepage "http://gittf.codeplex.com/"
  url "http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip"
  sha256 "91fd12e7db19600cc908e59b82104dbfbb0dbfba6fd698804a8330d6103aae74"

  head do
    url "https://git01.codeplex.com/gittf", :using => :git
    depends_on "maven" => :build
  end

  def install
    if build.stable?
      install_prefix = ""
    else
      system "mvn", "assembly:assembly"
      system "unzip", Dir["target/git-tf-*.zip"], "-dtarget"
      install_prefix = Dir["target/git-tf-*/"].first.to_s
    end

    libexec.install install_prefix + "git-tf"
    libexec.install install_prefix + "lib"
    (libexec + "native").install install_prefix + "native/macosx"

    bin.write_exec_script libexec/"git-tf"
    doc.install Dir["Git-TF_*", "ThirdPartyNotices*"]
  end

  def caveats; <<-EOS.undent
    This release removes support for TFS 2005 and 2008. Use a previous version if needed.
    EOS
  end

  test do
    system "#{bin}/git-tf"
  end
end
