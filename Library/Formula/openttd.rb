require 'formula'

class Openttd < Formula
  homepage 'http://www.openttd.org/'
  url 'http://us.binaries.openttd.org/binaries/releases/1.1.5/openttd-1.1.5-source.tar.gz'
  md5 '6bad4750c09782e04a987a326d798d8a'
  head 'git://git.openttd.org/openttd/trunk.git'

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
