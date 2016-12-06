require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sbuild < Formula
  homepage 'http://sbuild.tototec.de/sbuild/projects/sbuild/wiki'
  url 'http://sbuild.tototec.de/sbuild/attachments/download/57/sbuild-0.4.0-dist.zip'
  sha1 'f206a97c810d925f2bd06bc463c55d5cd7483ca5'

  def install
     libexec.install Dir['*']
     system "chmod +x #{libexec}/bin/sbuild"
     bin.install_symlink Dir["#{libexec}/bin/sbuild"]
  end

  test do
    system "sbuild --help"
  end
end
