require 'formula'

class GitFtp < Formula
	url 'https://github.com/resmo/git-ftp.git', :tag => '0.5.1'
	version '0.5.1'
	head 'https://github.com/resmo/git-ftp.git', :branch => 'develop'

	homepage 'http://github.com/resmo/git-ftp'

	depends_on 'curl'

  def install
    system "make", "prefix=#{prefix}", "MAN_FILE=#{man}", "install" # to install git-ftp and no man pages (needs pandoc which depends on cabel)
  end
end
