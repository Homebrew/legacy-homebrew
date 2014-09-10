require "formula"


class Panamax < Formula
  homepage "http://www.panamax.io"
  url "http://download.panamax.io/installer/panamax-0.2.0.tar.gz"
  sha1 "8ccbe1d5209bb926efb219ce25c6a2dd87f61a67"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "If upgrading the Panamax Installer, be sure to run 'panamax reinstall' to ensure compatibility with other Panamax components."
  end

  test do
    installed = File.exist?("#{prefix}/.panamax")
    assert installed
    assert_equal 0, $?.exitstatus
  end
end
