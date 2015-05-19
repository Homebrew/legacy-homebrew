class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "http://quex.org/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.65.4.tar.gz"
  sha256 "42245d5795d03ca053741947733660ac4a0d6d54abdd7d2fa9997a9f2bd4ef3f"

  head "http://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any
    sha256 "78981cf57de1b86adf12c2a7605aad9a8080f8824fe26281f3981f1bec48a978" => :yosemite
    sha256 "1a90be64b27e77441ce719ab44b3dc2aca5adf392f245056cd9ec32dabec50e2" => :mavericks
    sha256 "097c4f5030b4163f1c6544eba69eed8b00982a3c26e27d67702b5ff2e016da6e" => :mountain_lion
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
