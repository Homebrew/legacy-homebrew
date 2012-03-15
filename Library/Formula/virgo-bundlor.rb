require 'formula'

class VirgoBundlor < Formula

	homepage "http://www.eclipse.org/virgo/"
	# don't delete empty repository folders and work directory
	skip_clean :all
	version "1.1.0.M04"

	# have to add &dummy so file name is correct when downloaded
        url "http://eclipse.ialto.com/virgo/milestone/BNDLR/#{version}/bundlor-#{version}.zip"
	md5 '4dbc1723caa5041db5295d011e73c7d6'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install %w{ about/About.html about/epl-v10.html about/notice.html }
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/bundlor.sh'
  end
end
