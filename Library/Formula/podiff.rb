require 'formula'

class Podiff < Formula
  homepage 'http://puszcza.gnu.org.ua/software/podiff/'
  url 'http://download.gnu.org.ua/pub/release/podiff/podiff-1.1.tar.gz'
  sha1 'c354a42c215d0b7768b30c1db13729177cec4c7a'

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
    system "podiff -v"
  end
end
