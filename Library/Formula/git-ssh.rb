require 'formula'

class GitSsh < Formula
  homepage 'https://github.com/lemarsu/git-ssh'
  url 'https://github.com/lemarsu/git-ssh/tarball/v0.2.0'
  sha1 '147d18d5a310f8cb0530155402cbd8ac66e7fa97'

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
