class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text."
  homepage "http://www.memoryhole.net/~kyle/extract_url/"
  url "https://extracturl.googlecode.com/files/extract_url-1.5.8.tar.gz"
  sha256 "58eac907cb926deba74ab81e7503a1055fd3cbe20952f011d8e6b75da12d6bcc"

  depends_on "MIME::Parser" => :perl
  depends_on "HTML::Parser" => :perl
  depends_on "Pod::Usage" => :perl
  depends_on "Env" => :perl
  #depends_on "URI::Find" => :perl
  #depends_on "Curses::UI" => :perl
  depends_on "Getopt::Long" => :perl

  def install
    system "make", "man"
    mv "extract_url.pl", "extract_url"
    bin.install "extract_url"
    man1.install "extract_url.1"
  end

  test do
    system "extract_url", "--help"
  end

end
