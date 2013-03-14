require 'formula'

class GitTf < Formula
  homepage 'http://gittf.codeplex.com/'
  url 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.2.20130214.zip'
  sha1 '889c1bba6aba892e570a18a386654a50293efbd0'

  depends_on 'maven' unless build.stable?

  head do
    url 'https://git01.codeplex.com/gittf', :using => :git
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

  def test
    system "mvn", "test" unless build.stable?
    system "#{bin}/git-tf"
    system "git", "tf"
  end
end
