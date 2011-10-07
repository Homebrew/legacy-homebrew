require 'formula'

class GitSsh < Formula
  url 'https://github.com/lemarsu/git-ssh/tarball/v0.2.0'
  md5 '5d146666bce5df59aab648b6ee7370ad'
  homepage 'https://github.com/lemarsu/git-ssh'

  def install
    # Change loading of required code from libexec location (Cellar only)
    inreplace "bin/git-ssh" do |s|
      s.sub! /path = .*$/, "path = '#{libexec}'"
    end
    # Install main script
    bin.install "bin/git-ssh"
    # Install required code into libexec location (Cellar only)
    libexec.install Dir["lib/*"]
  end
end
