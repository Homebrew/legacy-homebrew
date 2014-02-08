require 'formula'

class Chuck < Formula
  homepage 'http://chuck.cs.princeton.edu/'
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.3.2.0.tgz'
  sha1 'a684ef41848a55de84e714dc6f644c38a1b69fd5'

  def install
    cd "src" do
      # On 10.9, chuck fails to set flags to link against the
      # private framework it needs
      # See: https://github.com/Homebrew/homebrew/issues/26519
      inreplace 'makefile.osx' do |s|
        s.change_make_var! 'LINK_EXTRAS',
          '-F/System/Library/PrivateFrameworks -weak_framework MultitouchSupport'
        s.remove_make_var! 'ISYSROOT'
      end

      system "make osx"
      bin.install "chuck"
    end
    (share/'chuck').install "examples/"
  end
end
