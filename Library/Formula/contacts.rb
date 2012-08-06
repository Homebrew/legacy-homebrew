require 'formula'

class Contacts < Formula
  url 'https://github.com/dhess/contacts/tarball/master'
  version '1.1a-3'
  homepage 'http://www.gnufoo.org/contacts/contacts.html'
  sha1 '644f449f0d01ddf62236ce82240f4757921cca17'

  def install
    system "make"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end
end
