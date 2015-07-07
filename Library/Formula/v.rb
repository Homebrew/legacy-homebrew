class V < Formula
  desc "Node version management"
  homepage "https://github.com/rupa/v"
  head "https://github.com/rupa/v.git"
  url "https://github.com/rupa/v/archive/v1.0.tar.gz"
  sha256 "fc25860c29a2d02908f4c2b6ecf0499e0121393a0ec13ec1c047f7a6ead100f1"

  def install
    bin.install "v"
    man1.install "v.1"
  end

  test do
    (testpath/".vimrc").write "set viminfo='25,\"50,n#{testpath}/.viminfo"
    system "/usr/bin/vim", "-u", testpath/".vimrc", "+wq", "test.txt"
    assert_equal "#{testpath}/test.txt", shell_output("#{bin}/v -a --debug").chomp
  end
end
