require 'formula'

class GitCal < Formula
  homepage 'https://github.com/k4rthik/git-cal'
  url 'https://github.com/k4rthik/git-cal/archive/v0.9.zip'
  version '0.9'
  sha1 'f4bf6f5b012761d7117dc0fefb754ad06f089af6'

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "git", "init"
    system "touch", "something"
    system "git", "add", "something"
    system "git", "commit", "-m", "'Some commit'"
    system "git", "cal"
  end
end
