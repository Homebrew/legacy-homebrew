require "formula"

class Imapsync < Formula
  homepage "http://ks.lamiral.info/imapsync/"
  url "https://fedorahosted.org/released/imapsync/imapsync-1.584.tgz"
  sha1 "c1de4558a2379416a9af4064e8922efab08e664d"

  head "https://git.fedorahosted.org/git/imapsync.git"

  resource "File::Copy::Recursive" do
    url "http://search.cpan.org/CPAN/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.38.tar.gz"
    sha1 "6c3a48c8ba70ad6b1ea97c4aac6b1f2d310a8e8d"
  end

  resource "Mail::IMAPClient" do
    url "http://search.cpan.org/CPAN/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz"
    sha1 "96cbe63b112cdd7c411566c5ae3ed8dafba4f7bd"
  end

  resource "Authen::NTLM" do
    url "http://search.cpan.org/CPAN/authors/id/N/NB/NBEBOUT/NTLM-1.09.tar.gz"
    sha1 "91064a6ce7ccf0eb8ef498a2f3dc3d30e9406dfe"
  end

  def install
    ENV.prepend_create_path 'PERL5LIB', libexec+'lib/perl5'

    resource("File::Copy::Recursive").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Mail::IMAPClient").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Authen::NTLM").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV['PERL5LIB'])
  end
end
