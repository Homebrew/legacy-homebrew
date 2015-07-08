class Lorem < Formula
  desc "Lorem Ipsum generator"
  homepage "https://github.com/per9000/lorem"
  url "https://github.com/per9000/lorem.git", :revision => "6da0a5ac4dcce0e2463a0d820baafde72210fbff"
  version "0.7.4"

  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end

  test do
    assert_equal "Lorem ipsum", shell_output("#{bin}/lorem -n 2").strip
  end
end
