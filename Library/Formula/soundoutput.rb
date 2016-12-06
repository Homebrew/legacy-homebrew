require 'formula'

class Soundoutput < Formula
  homepage 'https://github.com/neethouse/soundoutput'
  url 'https://github.com/neethouse/soundoutput/archive/1.0.2.tar.gz'
  sha1 '3eacbd99171d375becec3ee44f7b44e548740f26'

  depends_on :macos => :lion
  depends_on :xcode

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/soundoutput"
  end
end
