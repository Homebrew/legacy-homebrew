require 'formula'

class Lsxx < Formula
  homepage 'https://github.com/trapd00r/ls--'
  url 'https://github.com/trapd00r/ls--/zipball/v0.340'
  md5 'd352e309ca46327eb836fd63902a5c97'

  depends_on 'Term::ExtendedColor' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
    system "cp", "ls++.conf", ENV["HOME"] + "/.ls++.conf"
  end

  def test
    system "ls++ -v"
  end
end
