require 'formula'

class RdiffBackup < Formula
  homepage 'http://rdiff-backup.nongnu.org/'
  url 'http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz'
  sha1 '14ffe4f5b46a8a96ded536c1d03ae5e85faae318'

  depends_on 'librsync'
  depends_on :python

  def install
    python do
      system python, "setup.py", "--librsync-dir=#{python.site_packages}", "build"
      python.site_packages.install Dir['build/lib.macosx*/rdiff_backup']
      python.site_packages.install Dir['build/scripts-*/*']
      man1.install Dir['*.1']
      bin.install_symlink Dir["#{python.site_packages}/rdiff-backup*"]
    end
  end
end
