require "formula"


class Panamax < Formula
  homepage "http://www.panamax.io"
  url "http://download.panamax.io/installer/panamax-0.2.0.tar.gz"
  sha1 "5de8a05d835a956f8905edc7073f0a652943328f"

  def install
    system "./configure #{prefix}"
    system "make", "install"
    bin.install "panamax"
    opoo "If upgrading the Panamax Installer, be sure to run 'panamax reinstall' to ensure compatibility with other Panamax components."
  end

  test do
    installed = File.exist?("#{prefix}/.panamax")
    assert installed
    assert_equal 0, $?.exitstatus
  end
end
