class BottleVersion < Version
  def self._parse spec
    spec = Pathname.new(spec) unless spec.is_a? Pathname
    stem = spec.stem

    super
  end
end
