require "formula"

class GmailBackup < Formula
  homepage "http://www.gmail-backup.com/"
  url "https://gmail-backup-com.googlecode.com/files/gmail-backup-20110307.tar.gz"
  head "http://gmail-backup-com.googlecode.com/svn/trunk"
  sha1 "561c467b3cf12fab47304eac153586954f06b88b"

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
