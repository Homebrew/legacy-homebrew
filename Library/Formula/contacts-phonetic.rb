class ContactsPhonetic < Formula
  desc "Add phonetic names to contacts."
  homepage "https://github.com/Elethom/ContactsUtil-PhoneticName"
  url "https://github.com/Elethom/ContactsUtil-PhoneticName/archive/0.1.1.tar.gz"
  sha256 "3816152a62674870489b5780aa10b6bdb5adff9e55f79c19b6529a833859e15b"

  depends_on :macos => :el_capitan

  def install
    system "make"
    bin.install "contacts-phonetic"
  end
end
