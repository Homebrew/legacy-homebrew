require 'formula'

class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage 'https://github.com/jdberry/tag/'
  url 'https://github.com/jdberry/tag/archive/v0.8.1.tar.gz'
  sha1 '0778c0aeae3da7281271ab8f0fe4777b835dd5a9'
  head 'https://github.com/jdberry/tag.git'

  depends_on :macos => :mavericks

  def install
    system 'make'
    bin.install 'bin/tag'
  end

  test do
    test_tag = 'test_tag'
    test_file = Pathname.pwd+'test_file'
    touch test_file
    system "#{bin}/tag", '--add', test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
