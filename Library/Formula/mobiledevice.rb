class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"

  bottle do
    cellar :any
    sha256 "110dd69008feb20cbe6343169dfcc278d209e9430d59d44ab0bf6ce7eb920362" => :yosemite
    sha256 "18d5472c4b517413472be3b97ff66217d55690773ef952933e652dc8a57133bf" => :mavericks
    sha256 "19eb775bc12305341abe780c06308cf32f5fd6060227fefa4cd0f2ef28a3dae2" => :mountain_lion
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mobiledevice", "list_devices"
  end
end
