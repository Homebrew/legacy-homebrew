require 'formula'

class Unison < Formula
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.3.tar.gz'
  sha1 '74f1c087ee49dc1db4680ad779280f7333d5c968'

  bottle do
    cellar :any
    revision 1
    sha1 "dd7f286a9b2604953e8d0733c316d7e087a48016" => :yosemite
    sha1 "8ca37b6fc00c806cf7f453a4b4bf0b287280b2e5" => :mavericks
    sha1 "6972899653b6f368a0c9fd232504922414d5cbfa" => :mountain_lion
  end

  depends_on 'objective-caml' => :build

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end
