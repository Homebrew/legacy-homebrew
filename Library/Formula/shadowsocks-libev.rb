require 'formula'

class ShadowsocksLibev < Formula
  homepage 'https://github.com/madeye/shadowsocks-libev'
  url 'https://github.com/madeye/shadowsocks-libev.git'
  version '1.2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    usage:
        ss-local -s server_host -p server_port -l local_port -k password
        [-m encrypt_method] [-f pid_file] [-t timeout] [-c config_file]

        ss-redir -s server_host -p server_port -l local_port -k password
        [-m encrypt_method] [-f pid_file] [-t timeout] [-c config_file]

        ss-server -s server_host -p server_port -k password
        [-m encrypt_method] [-f pid_file] [-t timeout] [-c config_file]
    options:
        encrypt_method:         table, rc4
        pid_file:               valid path to the pid file
        timeout:                socket timeout in senconds
        config_file:            json format config file
    notes:
        ss-redir provides a transparent proxy function and only works on the
        Linux platform with iptables.
    EOS
    end

  test do
    system "false"
  end
end
