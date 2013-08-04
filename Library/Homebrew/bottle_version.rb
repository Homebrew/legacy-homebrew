class BottleVersion < Version
  def self._parse spec
    spec = Pathname.new(spec) unless spec.is_a? Pathname
    stem = spec.stem

    # e.g. perforce-2013.1.610569-x86_64
    m = /-([\d\.]+-x86(_64)?)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. ssh-copy-id-6.2p2.bottle.tar.gz
    m = /(\d\.(\d)+(p(\d)+)?)/.match(stem)
    return m.captures.first unless m.nil?

    super
  end
end
