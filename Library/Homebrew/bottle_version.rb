class BottleVersion < Version
  def self._parse spec
    spec = Pathname.new(spec) unless spec.is_a? Pathname
    stem = spec.stem

    # e.g. perforce-2013.1.610569-x86_64.mountain_lion.bottle.tar.gz
    m = /-([\d\.]+-x86(_64)?)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. x264-r2197.4.mavericks.bottle.tar.gz
    # e.g. lz4-r114.mavericks.bottle.tar.gz
    m = /-(r\d+\.?\d*)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. 00-5.0.5 from zpython-00-5.0.5.mavericks.bottle.tar.gz
    m = /(00-\d+\.\d+(\.\d+)+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. 1.6.39 from pazpar2-1.6.39.mavericks.bottle.tar.gz
    m = /-(\d+\.\d+(\.\d+)+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. ssh-copy-id-6.2p2.mountain_lion.bottle.tar.gz
    # e.g. icu4c-52.1.mountain_lion.bottle.tar.gz
    m = /-(\d+\.(\d)+(p(\d)+)?)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. 0_5_0 from disco-0_5_0.mavericks.bottle.tar.gz
    m = /-(\d+_\d+(_\d+)+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. 20120731 from fontforge-20120731.mavericks.bottle.tar.gz
    m = /-(\d{8})/.match(stem)
    return m.captures.first unless m.nil?

    super
  end
end
