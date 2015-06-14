require 'formula'

class Unison < Formula
  desc "Unison file synchronizer"
  homepage 'https://www.cis.upenn.edu/~bcpierce/unison/'
  url 'https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.3.tar.gz'
  sha256 'f40d3cfbe82078d79328b51acab3e5179f844135260c2f4710525b9b45b15483'

  bottle do
    cellar :any
    sha1 "05c2f2b41d9cf864901577829fb71e05fe66d25b" => :yosemite
    sha1 "681d82f73649d0580acfbce2a6ce66f32ad6da9c" => :mavericks
    sha1 "0d83d72a11c558eec59ae9aa20476165dc56cb85" => :mountain_lion
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
