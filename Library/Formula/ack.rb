require 'brewkit'

class Ack <ScriptFileFormula
  # NOTE you don't need to specify the version, usually it is determined
  # automatically by examination of the URL, however in this case our auto
  # determination magic is inadequete
  version '1.90'
  url "http://github.com/petdance/ack/raw/c03b98d10d44a6eca4218c5a729b07b43d12c8d1/ack"
  md5 'd15d059166beff6103d2401aa2d783c7'
  homepage 'http://betterthangrep.com/'
end
