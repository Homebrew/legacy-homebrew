require 'formula'

class GitTf < Formula
  homepage 'http://gittf.codeplex.com/'
  url 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.1.20130107.zip'
  sha1 'a6d9188d0e3b4b0e42a81563c7bacd1e692a985c'

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
