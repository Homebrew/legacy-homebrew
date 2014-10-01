require 'formula'

class P0f < Formula
  homepage 'http://lcamtuf.coredump.cx/p0f3/'
  url 'http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.07b.tgz'
  sha1 'ae2c4fbcddf2a5ced33abd81992405b93207e7c8'

  def install
    inreplace 'config.h', 'p0f.fp', "#{etc}/p0f/p0f.fp"
    system './build.sh'
    sbin.install 'p0f'
    (etc + 'p0f').install 'p0f.fp'
  end

  test do
    require 'base64'

    pcap = '1MOyoQIABAAAAAAAAAAAAP//AAAAAAAA92EsVI67DgBEAAAA' \
           'RAAAAAIAAABFAABAbvpAAEAGAAB/AAABfwAAAcv8Iyjt2/Pg' \
           'AAAAALAC///+NAAAAgQ/2AEDAwQBAQgKCyrc9wAAAAAEAgAA'
    (testpath / 'test.pcap').write(Base64.decode64(pcap))
    system "#{sbin}/p0f", '-r', 'test.pcap'
  end
end
