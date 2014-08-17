require 'formula'

class Amtterm < Formula
  head 'git://git.kraxel.org/amtterm'
  homepage 'http://www.kraxel.org/blog/linux/amtterm/'
  url 'http://www.kraxel.org/releases/amtterm/amtterm-1.3.tar.gz'
  sha1 'cfd199cc870f48a59caa89408b039239eab85322'

  resource "SOAP::Lite" do
    url "http://search.cpan.org/CPAN/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz"
    sha1 "b9e22c82a240737e87d6c720998feadcfb583768"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "make","prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
