class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "http://puszcza.gnu.org.ua/software/podiff/"
  url "http://download.gnu.org.ua/pub/release/podiff/podiff-1.1.tar.gz"
  sha256 "a97480109c26837ffa868ff629a32205622a44d8b89c83b398fb17352b5be6ff"

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats; <<-EOS.undent
    To use with git, add this to your .git/config or global git config file:

      [diff "podiff"]
      command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

    Then add the following line to the .gitattributes file in
    the directory with your PO files:

      *.po diff=podiff

    See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
