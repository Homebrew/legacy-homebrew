class LetMeIn < Formula
  desc "Add my IP to AWS security group(s)"
  homepage "https://github.com/rlister/let-me-in"
  url "https://github.com/rlister/let-me-in/archive/v0.0.3.tar.gz"
  sha256 "538ada5748d513a3a926d7795ddcbe13bf96c99e0921cdc4148ff38f0d196121"

  depends_on "go" => :build

  ## this works
  go_resource "github.com/aws/aws-sdk-go/aws" do
    url "github.com/aws/aws-sdk-go/aws.git", revision: 'f096b7d61df3d7d6d97f0e701f92616d1ea5420d'
  end

  ## this works
  go_resource "github.com/aws/aws-sdk-go/aws/awserr" do
    url "github.com/aws/aws-sdk-go/aws.git", revision: 'f096b7d61df3d7d6d97f0e701f92616d1ea5420d'
  end

  ## this DOES NOT work
  go_resource "github.com/aws/aws-sdk-go/service/ec2" do
    url "github.com/aws/aws-sdk-go/aws.git", revision: 'f096b7d61df3d7d6d97f0e701f92616d1ea5420d'
  end

  def install
    ENV["GOPATH"] = buildpath
    # system "go", "get", "github.com/aws/aws-sdk-go/aws"
    # system "go", "get", "github.com/aws/aws-sdk-go/aws/awserr"
    # system "go", "get", "github.com/aws/aws-sdk-go/service/ec2"
    system "go", "build", "let-me-in.go"
    bin.install "let-me-in"
  end

  test do
    ## I should write some tests
  end
end
