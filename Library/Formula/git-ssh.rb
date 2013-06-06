require 'formula'

class GitSsh < Formula
  homepage 'https://github.com/lemarsu/git-ssh'
  url 'https://github.com/lemarsu/git-ssh/archive/v0.2.0.tar.gz'
  sha1 'a3014db9ae65fcf135a5224a18313f40aa19c7d5'

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
