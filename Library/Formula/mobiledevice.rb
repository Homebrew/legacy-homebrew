class Mobiledevice < Formula
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    cur_version = shell_output("#{bin}/mobiledevice version").strip
    assert_match "#{version}", cur_version
    system("#{bin}/mobiledevice list_devices")
  end
end
