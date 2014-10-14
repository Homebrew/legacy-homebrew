require 'formula'

class Tag < Formula
  homepage 'https://github.com/jdberry/tag/'
  url 'https://github.com/jdberry/tag/archive/v0.7.5.tar.gz'
  sha1 'e1075a1068f6a4cb377144e162ee47c063a4a0d6'
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
