require 'formula'

class Contacts < Formula
  url 'https://github.com/dhess/contacts/tarball/v1.1a'
  version '1.1a'
  homepage 'http://www.gnufoo.org/contacts/contacts.html'
  sha1 '2e5c8b4d9302aa6d3652a559155a95d74b6ffb6c'

  def install
    system "make"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end
end
