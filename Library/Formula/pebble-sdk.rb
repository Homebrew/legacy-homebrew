require 'formula'

class PebbleSdk < Formula
  homepage 'https://developer.getpebble.com/2/'
  url 'https://s3.amazonaws.com/assets.getpebble.com/sdk2/PebbleSDK-2.0-BETA2.tar.gz'
  version '2.0-BETA2'
  sha1 '6c45a9a91d82444c77cc10523e9059927d155787'

  option 'with-binary', "If true, use a binary version of the ARM toolchain," +
    " instead of compiling from source"

  depends_on 'freetype' => :optional
  depends_on :python
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'libelf'
  depends_on 'texinfo'

  resource 'binary-pebble-arm-toolchain' do
    url 'http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk/arm-cs-tools-macos-universal-static.tar.gz'
    sha1 'b1baaf455140d3c6e3a889217bb83986fe6527a0'
  end

  class PebbleArmToolchain < Formula
    url 'https://github.com/pebble/arm-eabi-toolchain', :using => :git
  end

  def install
    prefix.install %w[Documentation Examples Pebble PebbleKit-Android
        PebbleKit-iOS bin tools requirements.txt version.txt]

    if build.with? 'binary'
      (prefix/'arm-cs-tools').install resource('binary-pebble-arm-toolchain')
    else
      PebbleArmToolchain.new.brew {
        ENV['PREFIX'] = prefix/'arm-cs-tools'
        system "make install-cross"
        (prefix/'arm-cs-tools').install
      }
    end
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

  test do
    system prefix/'arm-cs-tools'/'bin'/'arm-none-eabi-gcc', '--version'
  end
end
