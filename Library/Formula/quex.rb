require 'formula'

class Quex < Formula
  url 'http://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.60.2.tar.gz'
  homepage 'http://quex.org/'
  md5 '836b724616020db2e661e4758b265239'

  def install
    libexec.install ['demo', 'quex', 'quex-exe.py']

    # Use a shim script to set QUEX_PATH on the user's behalf
    bin.mkpath
    (bin+'quex').write <<-EOS.undent
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{libexec}/quex-exe.py" "$@"
    EOS
  end

  def test
    system "#{bin}/quex", "--help"
  end
end
