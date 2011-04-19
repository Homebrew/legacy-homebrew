require 'formula'

class Contacts < Formula
  url 'http://www.gnufoo.org/contacts/contacts1.1.tgz'
  homepage 'http://www.gnufoo.org/contacts/contacts.html'
  md5 '37b6a6a0312dabc4ad2ddd8805f93e12'

  def install
    system "make"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end
end
