class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "http://quex.org/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.65.11.zip"
  sha256 "5384fbff8645bfbdd5d6659b79aba9012a8db184d93d25026c764074b8beb503"

  head "http://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfcc7a5dad70e0fad0a1fd3f6cd78dbd988da4d13274b73c7aefba1eee4ec0b7" => :el_capitan
    sha256 "b76f2ca4cb65bbb94014e9194db70331a45f6243d778b8bfdf6962589a5d001a" => :yosemite
    sha256 "2610201d79df9356f5ae7af217b5d1cc32827b9096e081105fbf59415cc03815" => :mavericks
  end

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"
    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin+"quex").write <<-EOS.undent
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{libexec}/quex-exe.py" "$@"
    EOS

    if build.head?
      man1.install "doc/manpage/quex.1"
    else
      man1.install "manpage/quex.1"
    end
  end

  test do
    system bin/"quex", "-i", doc/"demo/C/000/simple.qx", "-o", "tiny_lexer"
    File.exist? "tiny_lexer"
  end
end
