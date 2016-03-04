class AwsKeychain < Formula
  desc "Uses OS X keychain for storage of AWS credentials."
  homepage "https://github.com/pda/aws-keychain"
  url "https://github.com/pda/aws-keychain/archive/v3.0.0.tar.gz"
  sha256 "3c9882d3b516b629303ca9a045fc50f6eb75fda25cd2452f10c47eda205e051f"

  def install
    bin.install "aws-keychain"
  end

  test do
    # aws-keychain is a simple shell script wrapper around built-in
    # keychain utilities. It is not possible to create a new
    # keychain without triggering a keychain prompt.
    system "aws-keychain --help || true"
  end
end
