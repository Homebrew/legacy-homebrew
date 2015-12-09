class Archivemail < Formula
  desc "Tool for archiving and compressing old email in mailboxes"
  homepage "http://archivemail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/archivemail/archivemail-0.9.0.tar.gz"
  sha256 "4b430e2fba6f24970a67bd61eef39d7eae8209c7bef001196b997be1916fc663"

  bottle do
    cellar :any_skip_relocation
    sha256 "f95de4796d99f6c4a2174e973bac2efe5edd42237f0916cccfc1ebcdfbce92ba" => :el_capitan
    sha256 "92456f5fd90d8151d2dbe666f6b945ed9f47b90e96dc60080f69d41cdd9775d5" => :yosemite
    sha256 "691e95f5a952a01cf632ebb4d1e3e1bf6b773184e554705ee1893219ac0b0a55" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    (testpath/"inbox").write <<-EOS.undent
      From MAILER-DAEMON Fri Jul  8 12:08:34 2011
      From: Author <author@example.com>
      To: Recipient <recipient@example.com>
      Subject: Sample message 1

      This is the body.

      From MAILER-DAEMON Fri Jul  8 12:08:34 2012
      From: Author <author@example.com>
      To: Recipient <recipient@example.com>
      Subject: Sample message 2

      This is the second body.
    EOS
    system bin/"archivemail", "--no-compress", "--date", "2012-01-01", (testpath/"inbox")
    assert File.exist?(testpath/"inbox_archive")
    assert_match "Sample message 1", File.read("inbox_archive")
    assert !File.read("inbox").include?("Sample message 1")
    assert_match "Sample message 2", File.read("inbox")
  end
end
