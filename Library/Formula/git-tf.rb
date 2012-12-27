require 'formula'

class GitTf < Formula
  homepage 'http://gittf.codeplex.com/'
  url 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.0.20121030.zip'
  sha1 '0c51b2cc6316f37b9daed5f06d080a12003d3810'
  
  depends_on 'maven' if build.devel? || build.head?
  
  devel do
    version '2.0.0.20121030'
    url 'https://git01.codeplex.com/gittf', :using => :git, :tag => 'Release_2.0.0.20121030'
  end
  
  head do
    url 'https://git01.codeplex.com/gittf', :using => :git
  end
  
  def startup_script name
  <<-EOS.undent
    #!/bin/sh
    exec "#{libexec}/#{name}" "$@"
  EOS
  end
  
  def install
    if build.devel? || build.head?
      system "mvn", "assembly:assembly"
      
      system "unzip", Dir['target/git-tf-*.zip'], "-dtarget"
      install_prefix = Dir['target/git-tf-*/'].to_s
    else
      install_prefix = ''
    end
    
    libexec.install install_prefix + 'git-tf'
    libexec.install install_prefix + 'lib'
    libexec.install install_prefix + 'native/macosx'
    
    (bin+"git-tf").write startup_script('git-tf')
    (share/"doc/git-tf").install Dir['Git-TF_*'] + Dir['ThirdPartyNotices*']
  end
  
  def test
    system "mvn", "test" if build.devel? || build.head?
    
    system "#{bin}/git-tf"
    system "git", "tf"
  end
end
