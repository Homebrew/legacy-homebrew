require 'formula'

class GitTf < Formula
  homepage 'http://gittf.codeplex.com/'
  url 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip'
  sha1 'a16f98aa1cd6bff2931b2fa361711ca7051258f4'

  head do
    url 'https://git01.codeplex.com/gittf', :using => :git
    depends_on 'maven'
  end

  def install
    if build.stable?
      install_prefix = ''
    else
      system 'mvn', 'assembly:assembly'
      system 'unzip', Dir['target/git-tf-*.zip'], "-dtarget"
      install_prefix = Dir['target/git-tf-*/'].first.to_s
    end

    libexec.install install_prefix + 'git-tf'
    libexec.install install_prefix + 'lib'
    (libexec + "native").install install_prefix + 'native/macosx'

    bin.write_exec_script libexec/'git-tf'
    (share/'doc/git-tf').install Dir['Git-TF_*', 'ThirdPartyNotices*']
  end

  def caveats; <<-EOS.undent
    This release removes support for TFS 2005 and 2008. Use a previous version if needed.
    EOS
  end

  test do
    system "#{bin}/git-tf"
  end
end
