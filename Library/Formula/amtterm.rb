class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "http://www.kraxel.org/blog/linux/amtterm/"
  url "http://www.kraxel.org/releases/amtterm/amtterm-1.4.tar.gz"
  sha256 "e10af2b02dbf66fb24abd292b9ddc6d86b31eea09887da5cb0eb8fb2ee900e21"

  head "git://git.kraxel.org/amtterm"

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz"
    sha256 "e4dee589ef7d66314b3dc956569b2541e0b917e834974e078c256571b6011efe"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/amtterm", "-h"
  end
end
