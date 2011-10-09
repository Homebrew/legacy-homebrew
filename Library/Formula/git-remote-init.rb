require 'formula'

class GitRemoteInit < Formula
  url 'https://github.com/juanpabloaj/git-remote-init/zipball/v0.0.1'
  homepage 'https://github.com/juanpabloaj/git-remote-init'
  md5 'a9c047bd7329cd63c7a04d1390ef04c9'
  def install
	  bin.install "bin/git-remote-init"
	  bin.install "bin/git-remote-save"
  end
end
