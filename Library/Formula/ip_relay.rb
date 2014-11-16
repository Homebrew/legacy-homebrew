require 'formula'

class IpRelay < Formula
  homepage 'http://www.stewart.com.au/ip_relay/'
  url 'http://www.stewart.com.au/ip_relay/ip_relay-0.71.tgz'
  sha1 '6644476f6b154218c77053658537e45b56286248'

  def install
    bin.install "ip_relay.pl" => "ip_relay"
  end
end
