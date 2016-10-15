require 'formula'

class Syn < Formula
  homepage 'https://github.com/stephencelis/syn'

  version '0.2.0'
  url 'https://github.com/stephencelis/syn/releases/download/v0.2.0/syn.zip'
  sha1 'b383f82f39293d863d7ebdad4d9c79ad806e0790'

  depends_on :macos => :lion

  def install
    bin.install 'syn'
    man1.install 'syn.1'
  end
end

