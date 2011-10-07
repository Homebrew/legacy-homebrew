require 'formula'

class Openttd < Formula
  url 'http://us.binaries.openttd.org/binaries/releases/1.1.0/openttd-1.1.0-source.tar.gz'
  head 'git://git.openttd.org/openttd/trunk.git'
  homepage 'http://www.openttd.org/'
  md5 'd5ca3357e5c7f995aa43414ff4d93cfb'

  depends_on 'lzo'
  depends_on 'xz'

  def install
    system "./configure", "--prefix-dir=#{prefix}"
    system "make bundle"

    def install_asset(url)
      ohai "Downloading asset: #{url}"
      curl url, '-O'

      file = File.basename url
      system '/usr/bin/unzip', '-qq', file
      rm file
    end

    cd 'bundle/OpenTTD.app/Contents/Resources' do
      cd 'data' do
        install_asset 'http://bundles.openttdcoop.org/opengfx/releases/0.3.3/opengfx-0.3.3.zip'
        install_asset 'http://bundles.openttdcoop.org/opensfx/releases/0.2.3/opensfx-0.2.3.zip'
      end
      cd 'gm' do
        install_asset 'http://bundles.openttdcoop.org/openmsx/releases/0.3.1/openmsx-0.3.1.zip'
      end
    end

    prefix.install 'bundle/OpenTTD.app'
  end

  def caveats; <<-EOS.undent
      OpenTTD.app installed to: #{prefix}
      If you have access to the sound and graphics files from the original
      Transport Tycoon Deluxe, you can install them by following the
      instructions in section 4.1 of #{prefix}/README
    EOS
  end
end
