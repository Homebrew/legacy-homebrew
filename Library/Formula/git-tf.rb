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
      install_prefix = Dir['target/git-tf-*/'].to_s
    end

    libexec.install install_prefix + 'git-tf'
    libexec.install install_prefix + 'lib'
    (libexec + "native").install install_prefix + 'native/macosx'

    bin.write_exec_script libexec/'git-tf'
    (share/'doc/git-tf').install Dir['Git-TF_*'] + Dir['ThirdPartyNotices*']
  end
  
  def caveats; <<-EOS.undent
    This release deprecates support for legacy Microsoft Team Foundation Server 
    versions (anything older to TFS 2010). If you still need support for 
    previous releases, install an older client from homebrew-versions:
      
      brew tap homebrew/versions
      brew install homebrew/versions/git-tf-2.0.2.20130214
    
    Or, just switch to the older client if you still have it installed:
      
      brew switch git-tf 2.0.2.20130214 
    EOS
  end

  test do
    system "#{bin}/git-tf"
  end
end
