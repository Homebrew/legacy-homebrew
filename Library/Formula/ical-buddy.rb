require 'formula'

class IcalBuddy < Formula
  url "http://hasseg.org/git-public/icalBuddy.git",
    :tag => '36058c4f05bebbc377f5dfa68b9be476f3d0a361',
    :using => :git
  homepage 'http://hasseg.org/icalBuddy/'
  version '1.7.18'

  head "http://hasseg.org/git-public/icalBuddy.git", :using => :git

  def install
    arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    sdk = MacOS.leopard? ? "10.5" : "10.6"

    inreplace "Makefile" do |s|
      s.gsub! "-arch i386 -arch ppc $(ARCH_64BIT)", "-arch #{arch}"
      s.gsub! "-mmacosx-version-min=10.5", "-mmacosx-version-min=#{sdk}"
    end

    system "make icalBuddy icalBuddy.1 icalBuddyLocalization.1 icalBuddyConfig.1"

    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
