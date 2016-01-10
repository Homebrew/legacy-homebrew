class Odo < Formula
  desc "Atomic odometer for the command-line"
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha256 "52133a6b92510d27dfe80c7e9f333b90af43d12f7ea0cf00718aee8a85824df5"

  bottle do
    cellar :any
    sha256 "066649031770814fe0991dc595f123a145f5c786e5efdc6142c4be7b11eb86be" => :yosemite
    sha256 "eda3760bca97cc11d11dadc2aabcbb76fef5c47022900e5c628eda1f46cf4adc" => :mavericks
    sha256 "218018e5ffcf9ce61836429440d28d2b0ca690f66a0491c9d42d9c7482459447" => :mountain_lion
  end

  def install
    system "make"
    man1.mkpath
    bin.mkpath
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "odo", "testlog"
  end
end
