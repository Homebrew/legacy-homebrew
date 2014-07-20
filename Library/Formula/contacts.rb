require 'formula'

# Use a sha1 instead of a tag, as the author has not provided a tag for
# this release. In fact, the author no longer uses this software, so it
# is a candidate for removal if no new maintainer is found.
class Contacts < Formula
  homepage 'http://www.gnufoo.org/contacts/contacts.html'
  url 'https://github.com/dhess/contacts/archive/4092a3c6615d7a22852a3bafc44e4aeeb698aa8f.tar.gz'
  version '1.1a-3'
  sha1 '79526dd96e5b5297daaae6327c79de9366f94c87'

  bottle do
    cellar :any
    sha1 "ab0a67bacf53d9f1e6320b34cbaf33cc50ffa8ed" => :mavericks
    sha1 "b6dcc58b8cc4d849a81718a72372a3571d8c48b6" => :mountain_lion
    sha1 "68aa40140ff5abed8464415a8d45cead2782a998" => :lion
  end

  depends_on :xcode => :build

  def install
    system "make", "SDKROOT=#{MacOS.sdk_path}"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end
end
