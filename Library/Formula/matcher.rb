require 'formula'

class Matcher < Formula
  homepage 'https://github.com/burke/matcher'
  url 'https://github.com/kballenegger/matcher/archive/v1.0.tar.gz'
  sha1 '62295f72ed47ee5f513ebaf8906d74b56f0a78ac'

  def install
    system 'make'
    system 'make', 'install'
  end

  test do
    system 'matcher -h'
  end
end
