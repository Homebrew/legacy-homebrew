class Rtf2latex2e < Formula
  desc "RTF-to-LaTeX translation"
  homepage "http://rtf2latex2e.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rtf2latex2e/rtf2latex2e-unix/2-2/rtf2latex2e-2-2-2.tar.gz"
  version "2.2.2"
  sha256 "eb742af22f2ae43c40ea1abc5f50215e04779e51dc9d91cac9276b98f91bb1af"

  def install
    system "make", "install", "prefix=#{prefix}", "CC=#{ENV.cc}"
  end

  def caveats; <<-EOS.undent
    Configuration files have been installed to:
      #{share}/rtf2latex2e
    EOS
  end

  test do
    (testpath/"test.rtf").write <<-'EOF'.undent
    {\rtf1\ansi
    {\b hello} world
    }
    EOF
    system "#{bin}/rtf2latex2e", "-n", "test.rtf"
    system %q(cat test.tex | grep '\textbf{hello} world')
  end
end
