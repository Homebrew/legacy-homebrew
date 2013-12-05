require 'formula'

class PebbleSdk < Formula
  homepage 'https://developer.getpebble.com/2/'
  url 'https://s3.amazonaws.com/assets.getpebble.com/sdk2/PebbleSDK-2.0-BETA2.tar.gz'
  version '2.0-BETA2'
  sha1 '6c45a9a91d82444c77cc10523e9059927d155787'

  depends_on 'freetype' => :recommended
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'libelf'
  depends_on 'texinfo'

  resource 'pebble-arm-toolchain' do
    url 'https://github.com/pebble/arm-eabi-toolchain', :using => :git, :tag => 'v2.0'
  end

  def install
    prefix.install %w[Documentation Examples Pebble PebbleKit-Android
        PebbleKit-iOS bin tools requirements.txt version.txt]

    resource('pebble-arm-toolchain').stage do
      system "make", "PREFIX=#{prefix}/arm-cs-tools", "install-cross"
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
    arm_gcc = prefix/'arm-cs-tools/bin/arm-none-eabi-gcc'
    system arm_gcc, '--version'

    (testpath/'test.c').write <<-EOS.undent
      int main() { return 0; }
    EOS
    system arm_gcc, '-o', testpath/'test', testpath/'test.c'

    assert File.exist?(testpath/'test')
  end
end
