class ContactsPhonetic < Formula
  desc "Add phonetic names to contacts."
  homepage "https://github.com/Elethom/ContactsUtil-PhoneticName"
  url "https://github.com/Elethom/ContactsUtil-PhoneticName/archive/0.2.tar.gz"
  sha256 "c6a5deccc7e8f20f89d96f9fde86aa4ae04dba5d7492dec680b839e2fbdfb247"

  depends_on :macos => :el_capitan

  def install
    system "make"
    bin.install "contacts-phonetic"
  end
end
