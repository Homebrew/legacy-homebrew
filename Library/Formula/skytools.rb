class Skytools < Formula
  desc "Database management tools from Skype to PostgreSQL"
  homepage "http://pgfoundry.org/projects/skytools/"
  url "http://pgfoundry.org/frs/download.php/3622/skytools-3.2.tar.gz"
  sha256 "0fa9c819ab50ca2cbcc5e71cd80ab734120c9d628667af08f9a95ca62086ab5f"

  # Works only with homebrew postgres:
  # https://github.com/Homebrew/homebrew/issues/16024
  depends_on "postgresql"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
