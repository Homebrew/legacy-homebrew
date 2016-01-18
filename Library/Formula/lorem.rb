class Lorem < Formula
  desc "Lorem Ipsum generator"
  homepage "https://github.com/per9000/lorem"
  url "https://github.com/per9000/lorem/archive/6da0a5ac4dcce0e2463a0d820baafde72210fbff.tar.gz"
  version "0.7.4"
  sha256 "bb103552d6532e4e0276a936b9cec02ceffd5dce56325f2bf53fed8203a26ae1"
  head "https://github.com/per9000/lorem.git"

  stable do
    # Patch to fix broken -q option in latest numbered release
    patch do
      url "https://github.com/per9000/lorem/commit/1e3167d15b1337665a236a1e65a582ad2e3dd994.diff"
      sha256 "b0675f2d6d939ab2adf0334a2ec20684b66b415e7b231e13cdbfc2608501283f"
    end
  end

  bottle :unneeded

  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}/lorem -n 2").strip.downcase
  end
end
