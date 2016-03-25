class GmailBackup < Formula
  desc "Backup and restore the content of your Gmail account"
  homepage "https://code.google.com/archive/p/gmail-backup-com/"
  url "https://gmail-backup-com.googlecode.com/files/gmail-backup-20110307.tar.gz"
  sha256 "caf7cb40ea580e506f90a6029a64fedaf1234093c729ca7e6e36efbd709deb93"
  head "http://gmail-backup-com.googlecode.com/svn/trunk"

  bottle :unneeded

  def install
    bin.install "gmail-backup.py" => "gmail-backup"
    libexec.install Dir["*"]

    ENV.prepend_path "PYTHONPATH", libexec
    bin.env_script_all_files(libexec, :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/gmail-backup", "--help"
  end
end
