#!/usr/bin/env ruby
#-*-mode: Ruby; coding: utf-8;-*-

require 'formula'

class Entr < Formula
  url 'http://entrproject.org/code/entr-2.2.tar.gz'
  homepage 'https://bitbucket.org/eradman/entr'
  version '2.2'
  sha1 '71eedf5d9397a08a231f0ab400f5aeec4f77571b'

  def install
    ENV['PREFIX'] = prefix
    ENV['MANPREFIX'] = man
    system "./configure"
    system "make"
    system "make install"
  end
end
