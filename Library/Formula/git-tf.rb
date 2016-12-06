require 'formula'

class GitTf < Formula
  homepage 'http://gittf.codeplex.com'
  url 'http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-1.0.0.20120809.zip'
  sha1 '9251f2cc522cfa43af5f69bfc22d29583b72ef92'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/#{name}" "$@"
    EOS
  end

  def install
    # brew into libexec
    libexec.install Dir['*']

    # gen the bin
    (bin+'git-tf').write startup_script('git-tf')
  end

  def test
    system "#{bin}/git-tf"
    system "git","tf"
  end
end
