class ContactsPhonetic < Formula
  desc "Add phonetic names to contacts."
  homepage "https://github.com/Elethom/ContactsUtil-PhoneticName"
  url "https://github.com/Elethom/ContactsUtil-PhoneticName/archive/0.1.tar.gz"
  sha256 "c593ebfbedb3beac202f1de51189cf2b92c4a8d3b9da2fad633bb31f6b58e731"

  depends_on :macos => :el_capitan

  def install
    system "make"
    bin.install "contacts-phonetic"
  end
end
