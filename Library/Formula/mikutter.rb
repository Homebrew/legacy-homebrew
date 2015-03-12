class Mikutter < Formula
  homepage "http://mikutter.hachune.net/"
  url "http://mikutter.hachune.net/bin/mikutter.3.2.2.tar.gz"
  version "3.2.2"
  sha256 "4a8b24a357ccd3132688f7ee97efb909a03a9b78976b19f92e3f50f56dd887ad"

  depends_on "gtk+"
  depends_on :x11

  def install
    Homebrew.install_gem_setup_path! "bundler"
    prefix.install Dir["./*"]
    prefix.cd do
        system "bundle", "config", "--local", "build.nokogiri", "--",
            "--use-system-libraries",
            "--with-xml2-include=\"$(xcrun --show-sdk-path)/usr/include/libxml2\""
        system "bundle", "install", "--path", "vendor/bundle"
    end
    open("mikutter.sh", "w+") do |script|
        script.puts "#!/bin/sh"
        script.puts "ruby \"#{prefix}/mikutter.rb\" $@"
    end
    bin.install "mikutter.sh" => "mikutter"
  end

  test do
    pid = Process::spawn "ruby #{prefix}/mikutter.rb"
	sleep 20 # waiting for mikutter to launch
	system "kill", pid.to_s
	assert_equal 0, $?.to_i
  end
end
