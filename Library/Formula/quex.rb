class Quex < Formula
  homepage "http://quex.org/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.65.4.tar.gz"
  sha256 "42245d5795d03ca053741947733660ac4a0d6d54abdd7d2fa9997a9f2bd4ef3f"

  head "http://svn.code.sf.net/p/quex/code/trunk"

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
