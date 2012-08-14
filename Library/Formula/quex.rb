require 'formula'

class Quex < Formula
  homepage 'http://quex.org/'
  url 'http://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.62.6.zip'
  sha1 'a773b9d44b4cf9d9cbfd289ab1420cffdc26ed32'

  def install
    libexec.install 'demo', 'quex', 'quex-exe.py'

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
