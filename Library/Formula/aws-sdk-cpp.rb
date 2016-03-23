require "set"

class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/master.zip"
  version "HEAD"
  sha256 "7cc52b097e8da9beba295564057529c8a019e8c651c1fcf062e8d1d996437ae8"
  # url "https://github.com/aws/aws-sdk-cpp/archive/0.9.6.tar.gz"
  # sha256 "cf2dad62e50c5c5cff88a4ad959af3aa402aa7e8aa1692bdf807052c0fe4aeb9"
  head "https://github.com/aws/aws-sdk-cpp.git"

  WITHOUT_OPTIONS = {
    "compute" => ["ec2", "elasticbeanstalk", "lambda"],
    "storage" => ["s3", "cloudfront", "elasticfilesystem", "glacier", "importexport", "storagegateway"],
    "database" => ["rds", "dynamodb", "elasticache", "redshift", "dms", "sdb"],
    "networking" => ["directconnect", "route53", "route53domains"],
    "devtools" => ["codecommit", "codedeploy", "codepipeline"],
    "management" => ["cloudformation", "cloudtrail", "config", "opsworks", "ecr", "ecs", "autoscaling", "support", "logs", "monitoring", "ssm"],
    "security" => ["identity-management", "access-management", "inspector", "waf", "iam", "cloudhsm", "acm", "ds", "kms", "sts"],
    "analytics" => ["datapipeline", "kinesis", "firehose", "marketplacecommerceanalytics"],
    "mobile" => ["cognito-identity", "cognito-sync", "devicefarm", "mobileanalytics", "sns"],
    "appservices" => ["apigateway", "cloudsearch", "cloudsearchdomain", "elastictranscoder", "sqs", "swf", "email"],
    "other" => ["elasticloadbalancing", "elasticmapreduce", "es", "events", "machinelearning", "queues", "transfer", "iot", "gamelift", "workspaces", "meteringmarketplace"],
  }.freeze

  WITHOUT_OPTIONS.each { |category, clients| option "without-#{category}", "Exclude clients: #{clients.join(", ")}" }

  option "with-custom-memory-management", "Build with custom memory management"

  option "with-static", "Build with static linking"

  depends_on "cmake" => :build

  def install
    # Find the list of all clients
    valid_clients = []
    Dir.foreach(".") do |f|
      if File.directory?(f) && f.start_with?("aws-cpp-sdk-") && !f.end_with?("-tests")
        valid_clients << f
      end
    end

    # Collect up clients to be excluded
    without_clients = []
    WITHOUT_OPTIONS.each do |category, clients|
      if build.without? category
        clients.each { |client| without_clients << "aws-cpp-sdk-#{client}" }
      end
    end

    # Subtract excluded clients from all clients to get BUILD_ONLY argument
    build_clients = (valid_clients.to_set - without_clients.to_set).to_a
    # CMake doesn't like being passed this name, and it's included when any
    # other client is built anyway.
    build_clients.delete "aws-cpp-sdk-core"
    if build_clients.empty?
      odie "All clients excluded by --without flags. Try changing flags."
    end

    custom_memory_management = (build.with? "custom-memory-management") ? 1 : 0
    static_linking = (build.with? "static-linking") ? 1 : 0

    args = std_cmake_args
    args << "-DCUSTOM_MEMORY_MANAGEMENT=#{custom_memory_management}"
    args << "-DSTATIC_LINKING=#{static_linking}"
    if without_clients.any?
      args << "-DBUILD_ONLY=#{build_clients.join(";")}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    mv Dir[lib/"mac/Release/*"].select { |f| File.file? f }, lib
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-laws-cpp-sdk-core"
    system "./test"
  end
end
