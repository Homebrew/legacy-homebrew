class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.8.1.tar.gz"
  sha256 "4ac5005dcffff4f03fe3885b2ab321a61d77df2fb862527f4a0d05d1f9280680"
  head "https://github.com/jdberry/tag.git"

  depends_on :macos => :mavericks

  def install
    system "make"
    bin.install "bin/tag"
  end

  test do
    test_tag = "test_tag"
    test_file = Pathname.pwd+"test_file"
    touch test_file
    system "#{bin}/tag", "--add", test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
