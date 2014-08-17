require 'formula'

class Rtf2latex2e < Formula
  homepage 'http://rtf2latex2e.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/rtf2latex2e/rtf2latex2e-unix/2-2/rtf2latex2e-2-2-2.tar.gz'
  version '2.2.2'
  sha1 'e5092341b4aa01940a5279fc7f7d8804fda60dd8'

  def install
    system "make", "install", "prefix=#{prefix}", "CC=#{ENV.cc}"
  end

  def caveats; <<-EOS.undent
    Configuration files have been installed to:
      #{share}/rtf2latex2e
    EOS
  end

  test do
    (testpath/'test.rtf').write <<-'EOF'.undent
    {\rtf1\ansi
    {\b hello} world
    }
    EOF
    system "#{bin}/rtf2latex2e", "-n", "test.rtf"
    system %q[cat test.tex | grep '\textbf{hello} world']
  end
end
