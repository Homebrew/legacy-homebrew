require 'formula'

class GmailBackup < Formula
  homepage 'http://www.gmail-backup.com/'
  url 'http://gmail-backup-com.googlecode.com/svn/tags/20110307'
  head 'http://gmail-backup-com.googlecode.com/svn/trunk'

  def install
    bin.install "gmail-backup.py" => "gmail-backup"
    libexec.install Dir["*"]

    ENV.prepend_path 'PYTHONPATH', libexec

    bin.env_script_all_files(libexec, :PYTHONPATH => ENV['PYTHONPATH'])
  end

  def test
    system "#{bin}/gmail-backup", "--help"
  end
end
