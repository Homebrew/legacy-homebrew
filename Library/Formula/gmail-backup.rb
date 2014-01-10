require 'formula'

class GmailBackup < Formula
  homepage 'http://www.gmail-backup.com/'
  url 'http://gmail-backup-com.googlecode.com/svn/tags/20110307'
  head 'http://gmail-backup-com.googlecode.com/svn/trunk'

  def install
    libexec.install Dir["*"]
    ENV.prepend_path 'PYTHONPATH', libexec
    (bin/'gmail-backup').write_env_script libexec/'gmail-backup.py', :PYTHONPATH => ENV['PYTHONPATH']
  end

  def test
    system "#{bin}/gmail-backup", "--help"
  end
end
