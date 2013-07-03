require 'formula'

# Use a sha1 instead of a tag, as the author has not provided a tag for
# this release. In fact, the author no longer uses this software, so it
# is a candidate for removal if no new maintainer is found.
class Contacts < Formula
  homepage 'http://www.gnufoo.org/contacts/contacts.html'
  url 'https://github.com/dhess/contacts/archive/4092a3c6615d7a22852a3bafc44e4aeeb698aa8f.tar.gz'
  version '1.1a-3'
  sha1 '79526dd96e5b5297daaae6327c79de9366f94c87'

  def install
    system "make"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end
end
