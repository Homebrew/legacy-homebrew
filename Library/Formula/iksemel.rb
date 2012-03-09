require 'formula'

class Iksemel < Formula
  homepage ''
  url 'http://iksemel.googlecode.com/files/iksemel-1.4.tar.gz'
  md5 '532e77181694f87ad5eb59435d11c1ca'

  depends_on 'gnutls'
  depends_on 'pkg-config' => :build
  
  def libgnutls_config_exists?
    test = `which libgnutls-config`
    return (test != "")
  end
  
  def create_libgnutls_config
    script = <<-EOS.undent
    #!/bin/bash
    if [ "$1" == "--version" ]; then
    pkg-config --modversion gnutls
    else
    pkg-config $1 gnutls
    fi
    EOS
    puts HOMEBREW_PREFIX
    File.open("#{HOMEBREW_PREFIX}/bin/libgnutls-config", 'w') {|f| f.write(script) }
    FileUtils.chmod 0775, "#{HOMEBREW_PREFIX}/bin/libgnutls-config"
  end
  
  def install
    if not libgnutls_config_exists?
      opoo "libgnutls-config doesn't exist, we will create one passing info to pkg-config"
      create_libgnutls_config
    end
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ikslint"
  end
end
