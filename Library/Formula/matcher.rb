require 'formula'

class Matcher < Formula
  homepage 'https://github.com/burke/matcher'
  url 'https://github.com/burke/matcher/archive/1.0.0.tar.gz'
  sha1 '47c4c47de5a94f36366c09d10508a338610b183d'

  def install
    system 'make'
    system 'make', 'install'
  end

  test do
    system 'matcher -h'
  end
end
