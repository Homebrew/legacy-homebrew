require 'formula'

class PebbleSdk < Formula
  homepage 'https://developer.getpebble.com/2/'
  url 'https://s3.amazonaws.com/assets.getpebble.com/sdk2/PebbleSDK-2.0-BETA2.tar.gz'
  version '2.0-BETA2'
  sha1 '6c45a9a91d82444c77cc10523e9059927d155787'

  depends_on 'freetype' => :optional
  depends_on :python2

  resource 'pebble-arm-toolchain' do
    url 'http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk/arm-cs-tools-macos-universal-static.tar.gz'
    sha1 'b1baaf455140d3c6e3a889217bb83986fe6527a0'
  end

  def self.var_dirs
    %w[Documentation Examples Pebble PebbleKit-Android PebbleKit-iOS bin tools]
  end

  def self.var_files
    %w[requirements.txt version.txt]
  end

  def install
    prefix.install PebbleSdk.var_dirs, PebbleSdk.var_files
    (prefix/'arm-cs-tools').install resource('pebble-arm-toolchain')
  end

  def caveats
    <<-EOS.undent
      You still need to install the requisite Python modules yourself,
      preferrably through pip. The requirements are in:
          #{prefix}/requirements.txt

      For example, they can be installed with:
          $ pip install -r #{prefix}/requirements.txt
      if using pip.
    EOS
  end

end
