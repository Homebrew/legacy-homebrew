require 'formula'

class Quex < Formula
  homepage 'http://quex.org/'
  url 'https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.64.8.tar.gz'
  sha1 'efe3d3f5fa0cf9a1130c16d1e0dd4e48cf72011b'

  def install
    libexec.install 'demo', 'quex', 'quex-exe.py'

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin+'quex').write <<-EOS.undent
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{libexec}/quex-exe.py" "$@"
    EOS
  end

  test do
    system "#{bin}/quex", "--help"
  end
end
