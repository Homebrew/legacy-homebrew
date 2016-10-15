require 'formula'

class RubyDownload < Formula
  homepage 'https://github.com/sheerun/ruby-download'
  url 'https://github.com/sheerun/ruby-download/archive/v20131102.tar.gz'
  sha1 '874bf2d9966400775899924fad926144a2a2d0c7'

  head 'https://github.com/sheerun/ruby-download.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/ruby-download --version | grep #{version}"
  end
end
