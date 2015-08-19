class Imapsync < Formula
  desc "Migrate or backup IMAP mail accounts"
  homepage "http://ks.lamiral.info/imapsync/"
  url "https://fedorahosted.org/released/imapsync/imapsync-1.607.tgz"
  sha256 "784331cfa6cc391751dcdc5290eba5d50bf3ddbe9b213f072b413941a3fe4f2a"

  head "https://git.fedorahosted.org/git/imapsync.git"

  bottle do
    sha1 "3e0967b9f61fd147242089ab6e93fd573fef7c31" => :yosemite
    sha1 "667c9e72e7b361147fa419e3b61fe8e021662d85" => :mavericks
    sha1 "a15bf0b97404cc06c9ca6b366e0fcce9cf4f554d" => :mountain_lion
  end

  resource "Unicode::String" do
    url "http://www.cpan.org/authors/id/G/GA/GAAS/Unicode-String-2.09.tar.gz"
    mirror "http://www.mcpan.org/authors/id/G/GA/GAAS/Unicode-String-2.09.tar.gz"
    sha256 "c817bedb954ea2d488bade56059028b99e0198f6826482e2f68fd6d78653faad"
  end

  resource "File::Copy::Recursive" do
    url "http://search.cpan.org/CPAN/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    sha256 "84ccbddf3894a88a2c2b6be68ff6ef8960037803bb36aa228b31944cfdf6deeb"
  end

  resource "Mail::IMAPClient" do
    url "http://search.cpan.org/CPAN/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz"
    sha256 "8a4503833ce87d980be2d54603d94de4b365c2369eab19b095216506ce40f663"
  end

  resource "Authen::NTLM" do
    url "http://search.cpan.org/CPAN/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    sha256 "c823e30cda76bc15636e584302c960e2b5eeef9517c2448f7454498893151f85"
  end

  resource "IO::Tee" do
    url "http://search.cpan.org/CPAN/authors/id/K/KE/KENSHAN/IO-Tee-0.64.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/K/KE/KENSHAN/IO-Tee-0.64.tar.gz"
    sha256 "3ed276b1c2d3511338653c2532e73753d284943c1a8f5159ff37fecc2b345ed6"
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

    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
