class Pop2imap < Formula
  desc "POP to IMAP sync or copy tool."
  homepage "http://www.linux-france.org/prj/pop2imap/pop2imap"
  url "http://www.linux-france.org/prj/pop2imap/dist/pop2imap-1.27.tgz"
  sha256 "8a4631928b915f2acd402113f40117ca5056aad875336e7bb2620e6c78da74e4"

  resource "Mail::POP3Client" do
    url "https://cpan.metacpan.org/authors/id/SDOWD/Mail-POP3Client-2.19.tar.gz"
    mirror "http://www.cpan.org/authors/id/S/SD/SDOWD/Mail-POP3Client-2.19.tar.gz"
    sha256 "1142d6247a93cb86b23ed8835553bb2d227ff8213ee2743e4155bb93f47acb59"
  end

  resource "Mail::IMAPClient" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz"
    sha256 "8a4503833ce87d980be2d54603d94de4b365c2369eab19b095216506ce40f663"
  end

  resource "Email::Simple" do
    url "http://www.cpan.org/authors/id/R/RJ/RJBS/Email-Simple-2.210.tar.gz"
    mirror "http://cpan.metacpan.org/authors/id/R/RJ/RJBS/Email-Simple-2.210.tar.gz"
    sha256 "c8633fa462538967c036e3077617de9e5e8f6acc68d25546ba1d5bb1e12bd319"
  end

  resource "Date::Manip" do
    url "https://cpan.metacpan.org/authors/id/SBECK/Date-Manip-6.53.tar.gz"
    mirror "http://www.cpan.org/authors/id/S/SB/SBECK//Date-Manip-6.53.tar.gz"
    sha256 "677aebc40e4e84eef548ac4c54095a19978137aaab9b39c8ee526be6a6f0cb6f"
  end

  resource "IO::Socket::SSL" do
    url "http://www.cpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.024.tar.gz"
    mirror "http://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.024.tar.gz"
    sha256 "dab3125b004b24ff8dfc003aa81c00c0f976a1bc34a75e1d8d9de9de837ce6c9"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "-c", "pop2imap"
    system "pod2man", "pop2imap", "pop2imap.1"
    bin.install "pop2imap"
    man1.install "pop2imap.1"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
