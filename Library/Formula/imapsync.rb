require "formula"

class Imapsync < Formula
  homepage "http://ks.lamiral.info/imapsync/"
  url "https://fedorahosted.org/released/imapsync/imapsync-1.584.tgz"
  sha1 "c1de4558a2379416a9af4064e8922efab08e664d"

  head "https://git.fedorahosted.org/git/imapsync.git"

  depends_on "File::Copy::Recursive" => :perl
  depends_on "Mail::IMAPClient" => :perl
  depends_on "Authen::NTLM" => :perl

  def install
    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
  end
end
