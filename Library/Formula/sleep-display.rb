require 'formula'

class SleepDisplay < Formula
  homepage 'https://github.com/kimhunter/SleepDisplay'
  url 'https://github.com/kimhunter/SleepDisplay/archive/master.zip'
  sha1 '18f771bc1ce7d89b0f533a2480142f9c7ca92707'
  version '1.0'

  def install
    bin.install "dist/1.0/x64/SleepDisplay"
  end

  test do
    system bin/'SleepDisplay', '--help'
  end
end
