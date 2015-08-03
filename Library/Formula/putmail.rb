class Putmail < Formula
  desc "MTA or SMTP client designed to replace the sendmail command"
  homepage "http://putmail.sourceforge.net/home.html"
  url "https://downloads.sourceforge.net/project/putmail/putmail.py/1.4/putmail.py-1.4.tar.bz2"
  sha256 "1f4e6f33496100ad89b8f029621fb78ab2f80258994c7cd8687fd46730df45be"

  def install
    bin.install "putmail.py"
    man1.install "man/man1/putmail.py.1"
    bin.install_symlink "putmail.py" => "putmail"
    man1.install_symlink "putmail.py.1" => "putmail.1"
  end
end
