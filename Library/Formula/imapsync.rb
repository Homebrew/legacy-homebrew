require "formula"

class Imapsync < Formula
  url "https://fedorahosted.org/released/imapsync/imapsync-1.584.tgz"
  homepage "http://ks.lamiral.info/imapsync/"
  sha1 "c1de4558a2379416a9af4064e8922efab08e664d"

  depends_on "File::Copy::Recursive" => :perl
  depends_on "Mail::IMAPClient" => :perl
  depends_on "Authen::NTLM" => :perl

  head "https://git.fedorahosted.org/git/imapsync.git"

  def install
    system "perl", "-c", "imapsync"
    system "pod2man", "imapsync", "imapsync.1"
    bin.install "imapsync"
    man1.install "imapsync.1"
  end

end
