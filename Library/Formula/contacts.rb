# Use a sha1 instead of a tag, as the author has not provided a tag for
# this release. In fact, the author no longer uses this software, so it
# is a candidate for removal if no new maintainer is found.
class Contacts < Formula
  desc "Command-line tool to access OS X's Contacts (formerly 'Address Book')"
  homepage "http://www.gnufoo.org/contacts/contacts.html"
  url "https://github.com/dhess/contacts/archive/4092a3c6615d7a22852a3bafc44e4aeeb698aa8f.tar.gz"
  version "1.1a-3"
  sha256 "e3dd7e592af0016b28e9215d8ac0fe1a94c360eca5bfbdafc2b0e5d76c60b871"

  bottle do
    cellar :any
    sha256 "9a9c89e40f9ccf4ec45cf63414eaf31266dfc9b71dc96d8c02f7ab2b38e8f346" => :mavericks
    sha256 "548051ca4c3209a63dda33a6c17103b8cd3ea817bc4090963dbb12ee1763dcc6" => :mountain_lion
    sha256 "842a3ef87a54aab40009788d034f6095f3c10223867d1b8d5b6e3c933b5e4800" => :lion
  end

  depends_on :xcode => :build

  def install
    system "make", "SDKROOT=#{MacOS.sdk_path}"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end
end
