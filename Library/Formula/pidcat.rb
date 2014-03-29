require 'formula'

class Pidcat < Formula
  homepage 'https://github.com/JakeWharton/pidcat'
  url 'https://github.com/JakeWharton/pidcat/archive/1.4.1.tar.gz'
  sha1 '89f806ae1fa3375ce188851c8c95fc1097467b82'
  head 'https://github.com/JakeWharton/pidcat.git'

  def install
    bin.install 'pidcat.py' => 'pidcat'
  end

  test do
    output = `#{bin}/pidcat --help`.strip
    assert_match /^usage: pidcat/, output
  end
end
