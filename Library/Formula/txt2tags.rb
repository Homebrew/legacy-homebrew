require 'formula'

class Txt2tags < Formula
  homepage 'http://txt2tags.org'
  url 'http://txt2tags.googlecode.com/files/txt2tags-2.6.tgz'
  sha1 '91bc47e02b9ec7f2fa39c8f7ff5c260164a74718'

  def install
    bin.install 'txt2tags'
    man1.install "doc/manpage.man" => "txt2tags.1"
  end
end
